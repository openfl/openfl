package openfl.display; #if !flash


import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import lime.graphics.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.graphics.GLTexture;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
import openfl.display.Stage;
import openfl.errors.IOError;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Image;
import js.html.ImageData;
import js.html.Uint8ClampedArray;
import js.Browser;
#end


@:autoBuild(openfl.Assets.embedBitmap())
class BitmapData implements IBitmapDrawable {
	
	
	private static var __base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	private static var __base64Encoder:BaseCode;
	
	public var height (default, null):Int;
	public var rect (default, null):Rectangle;
	public var transparent (default, null):Bool;
	public var width (default, null):Int;
	
	public var __worldTransform:Matrix;
	
	private var __buffer:GLBuffer;
	private var __loading:Bool;
	private var __texture:GLTexture;
	private var __valid:Bool;
	
	private var __sourceBytes:UInt8Array;
	
	#if js
	private var __sourceCanvas:CanvasElement;
	private var __sourceContext:CanvasRenderingContext2D;
	private var __sourceImage:Image;
	private var __sourceImageData:ImageData;
	private var __sourceImageDataChanged:Bool;
	#end
	
	
	public function new (width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF) {
		
		this.transparent = transparent;
		
		if (width > 0 && height > 0) {
			
			this.width = width;
			this.height = height;
			rect = new Rectangle (0, 0, width, height);
			
			#if js
			__createCanvas (width, height);
			#end
			
			if (!transparent) {
				
				fillColor = (0xFF << 24) | (fillColor & 0xFFFFFF);
				
			}
			
			__fillRect (new Rectangle (0, 0, width, height), fillColor);
			
		}
		
	}
	
	
	public function applyFilter (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {
		
		#if js
		if (!__valid || sourceBitmapData == null || !sourceBitmapData.__valid) return;
		
		__convertToCanvas ();
		__createImageData ();
		
		sourceBitmapData.__convertToCanvas ();
		sourceBitmapData.__createImageData ();
		
		filter.__applyFilter (__sourceImageData, sourceBitmapData.__sourceImageData, sourceRect, destPoint);
		
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function clone ():BitmapData {
		
		#if js
		__syncImageData ();
		
		if (!__valid) {
			
			return new BitmapData (width, height, transparent);
			
		} else if (__sourceImage != null) {
			
			return BitmapData.fromImage (new lime.graphics.Image (__sourceImage, width, height), transparent);
			
		} else {
			
			return BitmapData.fromCanvas (__sourceCanvas, transparent);
			
		}
		#else
		return null;
		#end
		
	}
	
	
	public function colorTransform (rect:Rectangle, colorTransform:ColorTransform):Void {
		
		// TODO, could we handle this with 'destination-atop' or 'source-atop' composition modes instead?
		
		#if js
		rect = __clipRect (rect);
		if (!__valid || rect == null) return;
		
		__convertToCanvas ();
		__createImageData ();
		
		var data = __sourceImageData.data;
		var stride = width * 4;
		var offset:Int;
		
		for (row in Std.int (rect.y)...Std.int (rect.height)) {
			
			for (column in Std.int (rect.x)...Std.int (rect.width)) {
				
				offset = (row * stride) + (column * 4);
				
				data[offset] = Std.int ((data[offset] * colorTransform.redMultiplier) + colorTransform.redOffset);
				data[offset + 1] = Std.int ((data[offset + 1] * colorTransform.greenMultiplier) + colorTransform.greenOffset);
				data[offset + 2] = Std.int ((data[offset + 2] * colorTransform.blueMultiplier) + colorTransform.blueOffset);
				data[offset + 3] = Std.int ((data[offset + 3] * colorTransform.alphaMultiplier) + colorTransform.alphaOffset);
				
			}
			
		}
		
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function copyChannel (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:Int, destChannel:Int):Void {
		
		#if js
		sourceRect = __clipRect (sourceRect);
		if (!__valid || sourceRect == null) return;
		
		if (destChannel == BitmapDataChannel.ALPHA && !transparent) return;
		if (sourceRect.width <= 0 || sourceRect.height <= 0) return;
		if (sourceRect.x + sourceRect.width > sourceBitmapData.width) sourceRect.width = sourceBitmapData.width - sourceRect.x;
		if (sourceRect.y + sourceRect.height > sourceBitmapData.height) sourceRect.height = sourceBitmapData.height - sourceRect.y;
		
		var destIdx = -1;
		
		if (destChannel == BitmapDataChannel.ALPHA) { 
			
			destIdx = 3;
			
		} else if (destChannel == BitmapDataChannel.BLUE) {
			
			destIdx = 2;
			
		} else if (destChannel == BitmapDataChannel.GREEN) {
			
			destIdx = 1;
			
		} else if (destChannel == BitmapDataChannel.RED) {
			
			destIdx = 0;
			
		} else {
			
			throw "Invalid destination BitmapDataChannel passed to BitmapData::copyChannel.";
			
		}
		
		var srcIdx = -1;
		
		if (sourceChannel == BitmapDataChannel.ALPHA) {
			
			srcIdx = 3;
			
		} else if (sourceChannel == BitmapDataChannel.BLUE) {
			
			srcIdx = 2;
			
		} else if (sourceChannel == BitmapDataChannel.GREEN) {
			
			srcIdx = 1;
			
		} else if (sourceChannel == BitmapDataChannel.RED) {
			
			srcIdx = 0;
			
		} else {
			
			throw "Invalid source BitmapDataChannel passed to BitmapData::copyChannel.";
			
		}
		
		sourceBitmapData.__convertToCanvas ();
		sourceBitmapData.__createImageData ();
		
		var srcData = sourceBitmapData.__sourceImageData.data;
		var srcStride = Std.int (sourceBitmapData.width * 4);
		var srcPosition = Std.int ((sourceRect.x * 4) + (srcStride * sourceRect.y) + srcIdx);
		var srcRowOffset = srcStride - Std.int (4 * sourceRect.width);
		var srcRowEnd = Std.int (4 * (sourceRect.x + sourceRect.width));
		
		__convertToCanvas ();
		__createImageData ();
		
		var destData = __sourceImageData.data;
		var destStride = Std.int (width * 4);
		var destPosition = Std.int ((destPoint.x * 4) + (destStride * destPoint.y) + destIdx);
		var destRowOffset = destStride - Std.int (4 * sourceRect.width);
		var destRowEnd = Std.int (4 * (destPoint.x + sourceRect.width));
		
		var length = Std.int (sourceRect.width * sourceRect.height);
		
		for (i in 0...length) {
			
			destData[destPosition] = srcData[srcPosition];
			
			srcPosition += 4;
			destPosition += 4;
			
			if ((srcPosition % srcStride) > srcRowEnd) {
				
				srcPosition += srcRowOffset;
				
			}
			
			if ((destPosition % destStride) > destRowEnd) {
				
				destPosition += destRowOffset;
				
			}
			
		}
		
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function copyPixels (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void {
		
		#if js
		if (!__valid || sourceBitmapData == null) return;
		
		if (sourceRect.x + sourceRect.width > sourceBitmapData.width) sourceRect.width = sourceBitmapData.width - sourceRect.x;
		if (sourceRect.y + sourceRect.height > sourceBitmapData.height) sourceRect.height = sourceBitmapData.height - sourceRect.y;
		if (sourceRect.width <= 0 || sourceRect.height <= 0) return;
		
		if (alphaBitmapData != null && alphaBitmapData.transparent) {
			
			if (alphaPoint == null) alphaPoint = new Point ();
			
			var tempData = clone ();
			tempData.copyChannel (alphaBitmapData, new Rectangle (alphaPoint.x, alphaPoint.y, sourceRect.width, sourceRect.height), new Point (sourceRect.x, sourceRect.y), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			sourceBitmapData = tempData;
			
		}
		
		__syncImageData ();
		
		if (!mergeAlpha) {
			
			if (transparent && sourceBitmapData.transparent) {
				
				__sourceContext.clearRect (destPoint.x, destPoint.y, sourceRect.width, sourceRect.height);
				
			}
			
		}
		
		sourceBitmapData.__syncImageData ();
		
		if (sourceBitmapData.__sourceImage != null) {
			
			__sourceContext.drawImage (sourceBitmapData.__sourceImage, Std.int (sourceRect.x), Std.int (sourceRect.y), Std.int (sourceRect.width), Std.int (sourceRect.height), Std.int (destPoint.x), Std.int (destPoint.y), Std.int (sourceRect.width), Std.int (sourceRect.height));
			
		} else if (sourceBitmapData.__sourceCanvas != null) {
			
			__sourceContext.drawImage (sourceBitmapData.__sourceCanvas, Std.int (sourceRect.x), Std.int (sourceRect.y), Std.int (sourceRect.width), Std.int (sourceRect.height), Std.int (destPoint.x), Std.int (destPoint.y), Std.int (sourceRect.width), Std.int (sourceRect.height));
			
		}
		#end
		
	}
	
	
	public function dispose ():Void {
		
		#if js
		__sourceImage = null;
		__sourceCanvas = null;
		__sourceContext = null;
		#end
		
		width = 0;
		height = 0;
		rect = null;
		__valid = false;
		
	}
	
	
	public function draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		#if js
		if (!__valid) return;
		
		__convertToCanvas ();
		__syncImageData ();
		
		var renderSession = new RenderSession ();
		renderSession.context = __sourceContext;
		renderSession.roundPixels = true;
		
		if (!smoothing) {
			
			untyped (__sourceContext).mozImageSmoothingEnabled = false;
			untyped (__sourceContext).webkitImageSmoothingEnabled = false;
			__sourceContext.imageSmoothingEnabled = false;
			
		}
		
		var matrixCache = source.__worldTransform;
		source.__worldTransform = matrix != null ? matrix : new Matrix ();
		source.__updateChildren (false);
		source.__renderCanvas (renderSession);
		source.__worldTransform = matrixCache;
		source.__updateChildren (true);
		
		if (!smoothing) {
			
			untyped (__sourceContext).mozImageSmoothingEnabled = true;
			untyped (__sourceContext).webkitImageSmoothingEnabled = true;
			__sourceContext.imageSmoothingEnabled = true;
			
		}
		
		__sourceContext.setTransform (1, 0, 0, 1, 0, 0);
		#end
		
	}
	
	
	public function encode (rect:Rectangle, compressor:Dynamic, byteArray:ByteArray = null):ByteArray {
		
		openfl.Lib.notImplemented ("BitmapData.encode");
		return null;
		
	}
	
	
	public function fillRect (rect:Rectangle, color:Int):Void {
		
		#if js
		rect = __clipRect (rect);
		if (!__valid || rect == null) return;
		
		__convertToCanvas ();
		__syncImageData ();
		
		if (rect.x == 0 && rect.y == 0 && rect.width == width && rect.height == height) {
			
			if (transparent && ((color & 0xFF000000) == 0)) {
				
				__sourceCanvas.width = width;
				return;
				
			}
			
		}
		
		__fillRect (rect, color);
		#end
		
	}
	
	
	public function floodFill (x:Int, y:Int, color:Int):Void {
		
		#if js
		if (!__valid) return;
		
		__convertToCanvas ();
		__createImageData ();
		
		var data = __sourceImageData.data;
		
		var offset = ((y * (width * 4)) + (x * 4));
		var hitColorR = data[offset + 0];
		var hitColorG = data[offset + 1];
		var hitColorB = data[offset + 2];
		var hitColorA = transparent ? data[offset + 3] : 0xFF;
		
		var r = (color & 0xFF0000) >>> 16;
		var g = (color & 0x00FF00) >>> 8;
		var b = (color & 0x0000FF);
		var a = transparent ? (color & 0xFF000000) >>> 24 : 0xFF;
		
		if (hitColorR == r && hitColorG == g && hitColorB == b && hitColorA == a) return;
		
		var dx = [ 0, -1, 1, 0 ];
		var dy = [ -1, 0, 0, 1 ];
		
		var queue = new Array<Int> ();
		queue.push (x);
		queue.push (y);
		
		while (queue.length > 0) {
			
			var curPointY = queue.pop ();
			var curPointX = queue.pop ();
			
			for (i in 0...4) {
				
				var nextPointX = curPointX + dx[i];
				var nextPointY = curPointY + dy[i];
				
				if (nextPointX < 0 || nextPointY < 0 || nextPointX >= width || nextPointY >= height) {
					
					continue;
					
				}
				
				var nextPointOffset = (nextPointY * width + nextPointX) * 4;
				
				if (data[nextPointOffset + 0] == hitColorR && data[nextPointOffset + 1] == hitColorG && data[nextPointOffset + 2] == hitColorB && data[nextPointOffset + 3] == hitColorA) {
					
					data[nextPointOffset + 0] = r;
					data[nextPointOffset + 1] = g;
					data[nextPointOffset + 2] = b;
					data[nextPointOffset + 3] = a;
				    
					queue.push(nextPointX);
					queue.push(nextPointY);
					
				}
				
			}
			
		}
		
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public static function fromBase64 (base64:String, type:String, onload:BitmapData -> Void):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		bitmapData.__loadFromBase64 (base64, type, onload);
		return bitmapData;
		
	}
	
	
	public static function fromBytes (bytes:ByteArray, rawAlpha:ByteArray = null, onload:BitmapData -> Void):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		bitmapData.__loadFromBytes (bytes, rawAlpha, onload);
		return bitmapData;
		
	}
	
	
	public static function fromFile (path:String, onload:BitmapData -> Void = null, onfail:Void -> Void = null):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		
		#if js
		bitmapData.__sourceImage = new Image ();	
		bitmapData.__sourceImage.onload = function (_) {
			
			bitmapData.width = bitmapData.__sourceImage.width;
			bitmapData.height = bitmapData.__sourceImage.height;
			bitmapData.rect = new Rectangle (0, 0, bitmapData.__sourceImage.width, bitmapData.__sourceImage.height);
			bitmapData.__valid = true;
			
			if (onload != null) {
				
				onload (bitmapData);
				
			}
			
		}
		
		bitmapData.__sourceImage.onerror = function (_) {
			
			bitmapData.__valid = false;
			if (onfail != null) {
				
				onfail();
				
			}
		}
		
		bitmapData.__sourceImage.src = path;
		
		// Another IE9 bug: loading 20+ images fails unless this line is added.
		// (issue #1019768)
		if (bitmapData.__sourceImage.complete) { }
		#end
		
		return bitmapData;
		
	}
	
	
	public static function fromImage (image:lime.graphics.Image, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		#if js
		bitmapData.__sourceImage = image.data;
		#else
		bitmapData.__sourceBytes = image.bytes;
		#end
		bitmapData.width = image.width;
		bitmapData.height = image.height;
		bitmapData.rect = new Rectangle (0, 0, image.width, image.height);
		bitmapData.__valid = true;
		return bitmapData;
		
	}
	
	
	#if js
	public static function fromCanvas (canvas:CanvasElement, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		bitmapData.width = canvas.width;
		bitmapData.height = canvas.height;
		bitmapData.rect = new Rectangle (0, 0, canvas.width, canvas.height);
		bitmapData.__createCanvas (canvas.width, canvas.height);
		bitmapData.__sourceContext.drawImage (canvas, 0, 0);
		return bitmapData;
		
	}
	#end
	
	
	public function generateFilterRect (sourceRect:Rectangle, filter:BitmapFilter):Rectangle {
		
		return sourceRect.clone ();
		
	}
	
	
	public function getBuffer (gl:GLRenderContext):GLBuffer {
		
		if (__buffer == null) {
			
			var data = [
				
				width, height, 0, 1, 1, 
				0, height, 0, 0, 1, 
				width, 0, 0, 1, 0, 
				0, 0, 0, 0, 0
				
			];
			
			__buffer = gl.createBuffer ();
			gl.bindBuffer (gl.ARRAY_BUFFER, __buffer);
			gl.bufferData (gl.ARRAY_BUFFER, new Float32Array (cast data), gl.STATIC_DRAW);
			gl.bindBuffer (gl.ARRAY_BUFFER, null);
			
		}
		
		return __buffer;
		
	}
	
	
	public function getColorBoundsRect (mask:Int, color:Int, findColor:Bool = true):Rectangle {
		
		return rect.clone ();
		
	}
	
	
	public function getPixel (x:Int, y:Int):Int {
		
		#if js
		if (!__valid || x < 0 || y < 0 || x >= width || y >= height) return 0;
		
		__convertToCanvas ();
		__createImageData ();
		
		var offset = (4 * y * width + x * 4);
		return (__sourceImageData.data[offset] << 16) | (__sourceImageData.data[offset + 1] << 8) | (__sourceImageData.data[offset + 2]);
		#else
		
		return 0;
		
		#end
		
	}
	
	
	public function getPixel32 (x:Int, y:Int):Int {
		
		#if js
		if (!__valid || x < 0 || y < 0 || x >= width || y >= height) return 0;
		
		__convertToCanvas ();
		__createImageData ();
		
		return __getInt32 ((4 * y * width + x * 4), __sourceImageData.data);
		#else
		
		return 0;
		
		#end
		
	}
	
	
	public function getPixels (rect:Rectangle):ByteArray {
		
		#if js
		if (!__valid) return null;
		
		__convertToCanvas ();
		__createImageData ();
		
		var byteArray = new ByteArray ();
		
		if (rect == null || rect.equals (this.rect)) {
			
			byteArray.length = __sourceImageData.data.length;
			byteArray.byteView.set (__sourceImageData.data);
			
		} else {
			
			var srcData = __sourceImageData.data;
			var srcStride = Std.int (width * 4);
			var srcPosition = Std.int ((rect.x * 4) + (srcStride * rect.y));
			var srcRowOffset = srcStride - Std.int (4 * rect.width);
			var srcRowEnd = Std.int (4 * (rect.x + rect.width));
			
			var length = Std.int (4 * rect.width * rect.height);
			byteArray.length = length;
			
			for (i in 0...length) {
				
				byteArray.__set (i, srcData[srcPosition++]);
				
				if ((srcPosition % srcStride) > srcRowEnd) {
					
					srcPosition += srcRowOffset;
					
				}
				
			}
			
		}
		
		byteArray.position = 0;
		
		return byteArray;
		
		#else
		
		return new ByteArray ();
		
		#end
		
	}
	
	
	public function getTexture (gl:GLRenderContext):GLTexture {
		
		if (__texture == null) {
			
			__texture = gl.createTexture ();
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			#if js
			if (__sourceCanvas != null) {
				
				gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, __sourceCanvas);
				
			} else {
				
				gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, __sourceImage);
				
			}
			#else
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, __sourceBytes);
			#end
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			gl.bindTexture (gl.TEXTURE_2D, null);
			
		}
		
		return __texture;
		
	}
	
	
	public function getVector (rect:Rectangle) {
		
		var pixels = getPixels (rect);
		var result = new Vector<UInt> ();
		
		for (i in 0...Std.int (pixels.length / 4)) {
			
			result.push (pixels.readUnsignedInt ());
			
		}
		
		return result;
		
	}
	
	
	public function histogram (hRect:Rectangle = null) {
		
		var rect = hRect != null ? hRect : new Rectangle (0, 0, width, height);
		var pixels = getPixels (rect);
		var result = [for (i in 0...4) [for (j in 0...256) 0]];
		
		for (i in 0...pixels.length) {
			
			++result[i % 4][pixels.readUnsignedByte ()];
			
		}
		
		return result;
		
	}
	
	
	public function hitTest (firstPoint:Point, firstAlphaThreshold:Int, secondObject:Dynamic, secondBitmapDataPoint:Point = null, secondAlphaThreshold:Int = 1):Bool {
		
		if (!__valid) return false;
		
		openfl.Lib.notImplemented ("BitmapData.hitTest");
		
		/*var type = Type.getClassName (Type.getClass (secondObject));
		firstAlphaThreshold = firstAlphaThreshold & 0xFFFFFFFF;
		
		var me = this;
		var doHitTest = function (imageData:ImageData) {
			
			// TODO: Use standard Haxe Type and Reflect classes?
			if (secondObject.__proto__ == null || secondObject.__proto__.__class__ == null || secondObject.__proto__.__class__.__name__ == null) return false;
			
			switch (secondObject.__proto__.__class__.__name__[2]) {
				
				case "Rectangle":
					
					var rect:Rectangle = cast secondObject;
					rect.x -= firstPoint.x;
					rect.y -= firstPoint.y;
					
					rect = me.__clipRect (me.rect);
					if (me.rect == null) return false;
					
					var boundingBox = new Rectangle (0, 0, me.width, me.height);
					if (!rect.intersects(boundingBox)) return false;
					
					var diff = rect.intersection(boundingBox);
					var offset = 4 * (Math.round (diff.x) + (Math.round (diff.y) * imageData.width)) + 3;
					var pos = offset;
					var boundR = Math.round (4 * (diff.x + diff.width));
					
					while (pos < offset + Math.round (4 * (diff.width + imageData.width * diff.height))) {
						
						if ((pos % (imageData.width * 4)) > boundR - 1) {
							
							pos += imageData.width * 4 - boundR;
							
						}
						
						if (imageData.data[pos] - firstAlphaThreshold >= 0) return true;
						pos += 4;
						
					}
					
					return false;
				
				case "Point":
					
					var point : Point = cast secondObject;
					var x = point.x - firstPoint.x;
					var y = point.y - firstPoint.y;
					
					if (x < 0 || y < 0 || x >= me.width || y >= me.height) return false;
					if (imageData.data[Math.round (4 * (y * me.width + x)) + 3] - firstAlphaThreshold > 0) return true;
					
					return false;
				
				case "Bitmap":
					
					throw "bitmapData.hitTest with a second object of type Bitmap is currently not supported for HTML5";
					return false;
				
				case "BitmapData":
					
					throw "bitmapData.hitTest with a second object of type BitmapData is currently not supported for HTML5";
					return false;
				
				default:
					
					throw "BitmapData::hitTest secondObject argument must be either a Rectangle, a Point, a Bitmap or a BitmapData object.";
					return false;
				
			}
			
		}
		
		if (!__locked) {
			
			__buildLease ();
			var ctx:CanvasRenderingContext2D = ___textureBuffer.getContext ('2d');
			var imageData = ctx.getImageData (0, 0, width, height);
			
			return doHitTest (imageData);
			
		} else {
			
			return doHitTest (__imageData);
			
		}*/
		
		return false;
		
	}
	
	
	public function lock ():Void {
		
		
		
	}
	
	
	public function noise (randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false):Void {
		
		if (!__valid) return;
		
		openfl.Lib.notImplemented ("BitmapData.noise");
		
		/*var generator = new MinstdGenerator (randomSeed);
		var ctx:CanvasRenderingContext2D = ___textureBuffer.getContext ('2d');
		
		var imageData = null;
		
		if (__locked) {
			
			imageData = __imageData;
			
		} else {
			
			imageData = ctx.createImageData (___textureBuffer.width, ___textureBuffer.height);
			
		}
		
		for (i in 0...(___textureBuffer.width * ___textureBuffer.height)) {
			
			if (grayScale) {
				
				imageData.data[i * 4] = imageData.data[i * 4 + 1] = imageData.data[i * 4 + 2] = low + generator.nextValue () % (high - low + 1);
				
			} else {
				
				imageData.data[i * 4] = if (channelOptions & BitmapDataChannel.RED == 0) 0 else low + generator.nextValue () % (high - low + 1);
				imageData.data[i * 4 + 1] = if (channelOptions & BitmapDataChannel.GREEN == 0) 0 else low + generator.nextValue () % (high - low + 1);
				imageData.data[i * 4 + 2] = if (channelOptions & BitmapDataChannel.BLUE == 0) 0 else low + generator.nextValue () % (high - low + 1);
				
			}
			
			imageData.data[i * 4 + 3] = if (channelOptions & BitmapDataChannel.ALPHA == 0) 255 else low + generator.nextValue () % (high - low + 1);
			
		}
		
		if (__locked) {
			
			__imageDataChanged = true;
			
		} else {
			
			ctx.putImageData (imageData, 0, 0);
			
		}*/
		
	}
	
	
	public function paletteMap (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, ?redArray:Array<Int>, ?greenArray:Array<Int>, ?blueArray:Array<Int>, ?alphaArray:Array<Int>):Void {
		
		#if js
		var memory = new ByteArray ();
		var sw:Int = Std.int (sourceRect.width);
		var sh:Int = Std.int (sourceRect.height);
		
		memory.length = ((sw * sh) * 4);
		memory = getPixels (sourceRect);
		memory.position = 0;
		Memory.select (memory);
		
		var position:Int, pixelValue:Int, r:Int, g:Int, b:Int, color:Int;
		
		for (i in 0...(sh * sw)) {
			
			position = i * 4;
			pixelValue = cast Memory.getI32 (position);
			
			r = (pixelValue >> 8) & 0xFF;
			g = (pixelValue >> 16) & 0xFF;
			b = (pixelValue >> 24) & 0xFF;
			
			color = __flipPixel ((0xff << 24) |
				redArray[r] | 
				greenArray[g] | 
				blueArray[b]);
			
			Memory.setI32 (position, color);
			
		}
		
		memory.position = 0;
		var destRect = new Rectangle (destPoint.x, destPoint.y, sw, sh);
		setPixels (destRect, memory);
		Memory.select (null);
		#end
		
	}
	
	
	public function perlinNoise (baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7, grayScale:Bool = false, offsets:Array<Point> = null):Void {
		
		openfl.Lib.notImplemented ("BitmapData.perlinNoise");
		
	}
	
	
	public function scroll (x:Int, y:Int):Void {
		
		openfl.Lib.notImplemented ("BitmapData.scroll");
		
	}
	
	
	public function setPixel (x:Int, y:Int, color:Int):Void {
		
		#if js
		if (!__valid || x < 0 || y < 0 || x >= this.width || y >= this.height) return;
		
		__convertToCanvas ();
		__createImageData ();
		
		var offset = (4 * y * width + x * 4);
		
		__sourceImageData.data[offset] = (color & 0xFF0000) >>> 16;
		__sourceImageData.data[offset + 1] = (color & 0x00FF00) >>> 8;
		__sourceImageData.data[offset + 2] = (color & 0x0000FF);
		if (transparent) __sourceImageData.data[offset + 3] = (0xFF);
		
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function setPixel32 (x:Int, y:Int, color:Int):Void {
		
		#if js
		if (!__valid || x < 0 || y < 0 || x >= this.width || y >= this.height) return;
		
		__convertToCanvas ();
		__createImageData ();
		
		var offset = (4 * y * width + x * 4);
		
		__sourceImageData.data[offset] = (color & 0x00FF0000) >>> 16;
		__sourceImageData.data[offset + 1] = (color & 0x0000FF00) >>> 8;
		__sourceImageData.data[offset + 2] = (color & 0x000000FF);
		
		if (transparent) {
			
			__sourceImageData.data[offset + 3] = (color & 0xFF000000) >>> 24;
			
		} else {
			
			__sourceImageData.data[offset + 3] = (0xFF);
			
		}
		
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function setPixels (rect:Rectangle, byteArray:ByteArray):Void {
		
		#if js
		rect = __clipRect (rect);
		if (!__valid || rect == null) return;
		
		__convertToCanvas ();
		
		var len = Math.round (4 * rect.width * rect.height);
		
		if (rect.x == 0 && rect.y == 0 && rect.width == width && rect.height == height) {
			
			if (__sourceImageData == null) {
				
				__sourceImageData = __sourceContext.createImageData (width, height);
				
			}
			
			__sourceImageData.data.set (byteArray.byteView);
			
		} else {
			
			__createImageData ();
			
			var offset = Math.round (4 * width * rect.y + rect.x * 4);
			var pos = offset;
			var boundR = Math.round (4 * (rect.x + rect.width));
			var data = __sourceImageData.data;
			
			for (i in 0...len) {
				
				if (((pos) % (width * 4)) > boundR - 1) {
					
					pos += width * 4 - boundR;
					
				}
				
				data[pos] = byteArray.readByte ();
				pos++;
				
			}
			
		}
		
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function setVector (rect:Rectangle, inputVector:Vector<UInt>) {
		
		#if js
		var byteArray = new ByteArray ();
		byteArray.length = inputVector.length * 4;
		
		for (color in inputVector) {
			
			byteArray.writeUnsignedInt (color);
			
		}
		
		byteArray.position = 0;
		setPixels (rect, byteArray);
		#end
		
	}
	
	
	public function threshold (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000, mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int {
		
		#if js
		if (sourceBitmapData == this && sourceRect.equals(rect) && destPoint.x == 0 && destPoint.y == 0) {
			
			var hits = 0;
			
			threshold = __flipPixel (threshold);
			color = __flipPixel (color);
			
			var memory = new ByteArray ();
			memory.length  = width * height * 4;
			memory = getPixels (rect);
			memory.position = 0;
			Memory.select (memory);
			
			var thresholdMask:Int = cast threshold & mask;

			var width_yy:Int, position:Int, pixelMask:Int, pixelValue, i, test;
			
			for (yy in 0...height) {
				
				width_yy = width * yy;
				
				for (xx in 0...width) {
					
					position = (width_yy + xx) * 4;
					pixelValue = Memory.getI32 (position);
					pixelMask = cast pixelValue & mask;
					
					i = __ucompare (pixelMask, thresholdMask);
					test = false;
					
					if (operation == "==") { test = (i == 0); }
					else if (operation == "<") { test = (i == -1);}
					else if (operation == ">") { test = (i == 1); }
					else if (operation == "!=") { test = (i != 0); }
					else if (operation == "<=") { test = (i == 0 || i == -1); }
					else if (operation == ">=") { test = (i == 0 || i == 1); }
					
					if (test) {
						
						Memory.setI32 (position, color);
						hits++;
						
					}
					
				}
				
			}
			
			memory.position = 0;
			setPixels (rect, memory);
			Memory.select (null);
			return hits;
			
		} else {
			
			var sx = Std.int (sourceRect.x);
			var sy = Std.int (sourceRect.y);
			var sw = Std.int (sourceBitmapData.width);
			var sh = Std.int (sourceBitmapData.height);
			
			var dx = Std.int (destPoint.x);
			var dy = Std.int (destPoint.y);
			
			var bw:Int = width - sw - dx;
			var bh:Int = height - sh - dy;
			
			var dw:Int = (bw < 0) ? sw + (width - sw - dx) : sw;
			var dh:Int = (bw < 0) ? sh + (height - sh - dy) : sh;
			
			var hits = 0;
			
			threshold = __flipPixel (threshold);
			color = __flipPixel (color);
			
			var canvasMemory = (sw * sh) * 4;
			var sourceMemory = 0;
			
			if (copySource) {
				
				sourceMemory = (sw * sh) * 4;
				
			}
			
			var totalMemory = (canvasMemory + sourceMemory);
			var memory = new ByteArray();
			memory.length = totalMemory;
			memory.position = 0;
			var bitmapData = sourceBitmapData.clone ();
			var pixels = bitmapData.getPixels (sourceRect);
			memory.writeBytes (pixels);
			memory.position = canvasMemory;
			
			if (copySource) {
				
				memory.writeBytes (pixels);
				
			}
			
			memory.position = 0;
			Memory.select (memory);
			
			var thresholdMask:Int = cast threshold & mask;
			
			var position:Int, pixelMask:Int, pixelValue, i, test;
			
			for (yy in 0...dh) {
				
				for (xx in 0...dw) {
					
					position = ((xx + sx) + (yy + sy) * sw) * 4;
					pixelValue = Memory.getI32 (position);
					pixelMask = cast pixelValue & mask;
					
					i = __ucompare (pixelMask, thresholdMask);
					test = false;
					
					if (operation == "==") { test = (i == 0); }
					else if (operation == "<") { test = (i == -1);}
					else if (operation == ">") { test = (i == 1); }
					else if (operation == "!=") { test = (i != 0); }
					else if (operation == "<=") { test = (i == 0 || i == -1); }
					else if (operation == ">=") { test = (i == 0 || i == 1); }
					
					if (test) {
						
						Memory.setI32 (position, color);
						hits++;
						
					} else if (copySource) {
						
						Memory.setI32 (position, Memory.getI32 (canvasMemory + position));
						
					}
					
				}
				
			}
			
			memory.position = 0;	
			bitmapData.setPixels (sourceRect, memory);
			copyPixels (bitmapData, bitmapData.rect, destPoint);
			Memory.select (null);
			return hits;
			
		}
		#else
		return 0;
		#end
		
	}
	
	
	public function unlock (changeRect:Rectangle = null):Void {
		
		
		
	}
	
	
	private static function __base64Encode (bytes:ByteArray):String {
		
		#if js
		var extension = switch (bytes.length % 3) {
			
			case 1: "==";
			case 2: "=";
			default: "";
			
		}
		
		if (__base64Encoder == null) {
			
			__base64Encoder = new BaseCode (Bytes.ofString (__base64Chars));
			
		}
		
		return __base64Encoder.encodeBytes (Bytes.ofData (cast bytes.byteView)).toString () + extension;
		#else
		return "";
		#end
		
	}
	
	
	private function __clipRect (r:Rectangle):Rectangle {
		
		if (r == null) return null;
		
		if (r.x < 0) {
			
			r.width -= -r.x;
			r.x = 0;
			
			if (r.x + r.width <= 0) return null;
			
		}
		
		if (r.y < 0) {
			
			r.height -= -r.y;
			r.y = 0;
			
			if (r.y + r.height <= 0) return null;
			
		}
		
		if (r.x + r.width >= this.width) {
			
			r.width -= r.x + r.width - this.width;
			
			if (r.width <= 0) return null;
			
		}
		
		if (r.y + r.height >= this.height) {
			
			r.height -= r.y + r.height - this.height;
			
			if (r.height <= 0) return null;
			
		}
		
		return r;
		
	}
	
	
	#if js
	private function __convertToCanvas ():Void {
		
		if (__loading) return;
		
		if (__sourceImage != null) {
			
			if (__sourceCanvas == null) {
				
				__createCanvas (__sourceImage.width, __sourceImage.height);
				__sourceContext.drawImage (__sourceImage, 0, 0);
				
			}
			
			__sourceImage = null;
			
		}
		
	}
	
	
	private function __createCanvas (width:Int, height:Int):Void {
		
		if (__sourceCanvas == null) {
			
			__sourceCanvas = cast Browser.document.createElement ("canvas");		
			__sourceCanvas.width = width;
			__sourceCanvas.height = height;
			
			if (!transparent) {
				
				if (!transparent) __sourceCanvas.setAttribute ("moz-opaque", "true");
				__sourceContext = untyped __js__ ('this.__sourceCanvas.getContext ("2d", { alpha: false })');
				
			} else {
				
				__sourceContext = __sourceCanvas.getContext ("2d");
				
			}
			
			untyped (__sourceContext).mozImageSmoothingEnabled = false;
			untyped (__sourceContext).webkitImageSmoothingEnabled = false;
			__sourceContext.imageSmoothingEnabled = false;
			__valid = true;
			
		}
		
	}
	
	
	private function __createImageData ():Void {
		
		if (__sourceImageData == null) {
			
			__sourceImageData = __sourceContext.getImageData (0, 0, width, height);
			
		}
		
	}
	#end
	
	
	private function __fillRect (rect:Rectangle, color:Int) {
		
		#if js
		var a = (transparent) ? ((color & 0xFF000000) >>> 24) : 0xFF;
		var r = (color & 0x00FF0000) >>> 16;
		var g = (color & 0x0000FF00) >>> 8;
		var b = (color & 0x000000FF);
		
		__sourceContext.fillStyle = 'rgba(' + r + ', ' + g + ', ' + b + ', ' + (a / 255) + ')';
		__sourceContext.fillRect (rect.x, rect.y, rect.width, rect.height);
		#end
		
	}
	
	
	@:noCompletion private static inline function __flipPixel (pixel:Int):Int {
		
		return (pixel & 0xFF) << 24 | (pixel >>  8 & 0xFF) << 16 | (pixel >> 16 & 0xFF) <<  8 | (pixel >> 24 & 0xFF);
		
	}
	
	
	#if js
	private function __getInt32 (offset:Int, data:Uint8ClampedArray) {
		
		return (transparent ? data[offset + 3] : 0xFF) << 24 | data[offset] << 16 | data[offset + 1] << 8 | data[offset + 2]; 
		
	}
	#end
	
	
	private static function __isJPG (bytes:ByteArray) {
		
		bytes.position = 0;
		return bytes.readByte () == 0xFF && bytes.readByte () == 0xD8;
		
	}
	
	
	private static function __isPNG (bytes:ByteArray) {
		
		bytes.position = 0;
		return (bytes.readByte () == 0x89 && bytes.readByte () == 0x50 && bytes.readByte () == 0x4E && bytes.readByte () == 0x47 && bytes.readByte () == 0x0D && bytes.readByte () == 0x0A && bytes.readByte () == 0x1A && bytes.readByte () == 0x0A);
		
	}
	
	private static function __isGIF (bytes:ByteArray) {
		
		bytes.position = 0;
		
		if (bytes.readByte () == 0x47 && bytes.readByte () == 0x49 && bytes.readByte () == 0x46 && bytes.readByte () == 38) {
			
			var b = bytes.readByte ();
			return ((b == 7 || b == 9) && bytes.readByte () == 0x61);
			
		}
		
		return false;
		
	}
	
	
	private inline function __loadFromBase64 (base64:String, type:String, ?onload:BitmapData -> Void):Void {
		
		#if js
		__sourceImage = cast Browser.document.createElement ("img");
		
		var image_onLoaded = function (event) {
			
			if (__sourceImage == null) {
				
				__sourceImage = event.target;
				
			}
			
			width = __sourceImage.width;
			height = __sourceImage.height;
			rect = new Rectangle (0, 0, width, height);
			
			__valid = true;
			
			if (onload != null) {
				
				onload (this);
				
			}
			
		}
		
		__sourceImage.addEventListener ("load", image_onLoaded, false);
		__sourceImage.src = "data:" + type + ";base64," + base64;
		#end
		
	}
	
	
	private inline function __loadFromBytes (bytes:ByteArray, rawAlpha:ByteArray = null, ?onload:BitmapData -> Void):Void {
		
		#if js
		var type = "";
		
		if (__isPNG (bytes)) {
			
			type = "image/png";
			
		} else if (__isJPG (bytes)) {
			
			type = "image/jpeg";
			
		} else if (__isGIF (bytes)) {
			
			type = "image/gif";
			
		} else {
			
			throw new IOError ("BitmapData tried to read a PNG/JPG ByteArray, but found an invalid header.");
			
		}
		
		if (rawAlpha != null) {
			
			__loadFromBase64 (__base64Encode (bytes), type, function (_) {
				
				__convertToCanvas ();
				__createImageData ();
				
				var data = __sourceImageData.data;
				
				for (i in 0...rawAlpha.length) {
					
					data[i * 4 + 3] = rawAlpha.readUnsignedByte ();
					
				}
				
				__sourceImageDataChanged = true;
				
				if (onload != null) {
					
					onload (this);
					
				}
				
			});
			
		} else {
			
			__loadFromBase64 (__base64Encode (bytes), type, onload);
			
		}
		#end
		
	}
	
	
	public function __renderCanvas (renderSession:RenderSession):Void {
		
		#if js
		if (!__valid) return;
		
		__syncImageData ();
		
		var context = renderSession.context;
		
		if (__worldTransform == null) __worldTransform = new Matrix ();
		
		context.globalAlpha = 1;
		var transform = __worldTransform;
		
		if (renderSession.roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
		if (__sourceImage != null) {
			
			context.drawImage (__sourceImage, 0, 0);
			
		} else {
			
			context.drawImage (__sourceCanvas, 0, 0);
			
		}
		#end
		
	}
	
	
	public function __renderMask (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	#if js
	private function __syncImageData ():Void {
		
		if (__sourceImageDataChanged) {
			
			__sourceContext.putImageData (__sourceImageData, 0, 0);
			__sourceImageData = null;
			__sourceImageDataChanged = false;
			
		}
		
	}
	#end
	
	
	@:noCompletion static public function __ucompare (n1:Int, n2:Int) : Int {
		
		var tmp1 : Int;
		var tmp2 : Int;
		
		tmp1 = (n1 >> 24) & 0x000000FF;
		tmp2 = (n2 >> 24) & 0x000000FF;
		
		if (tmp1 != tmp2) {
			
			return (tmp1 > tmp2 ? 1 : -1);
			
		} else {
			
			tmp1 = (n1 >> 16) & 0x000000FF;
			tmp2 = (n2 >> 16) & 0x000000FF;
			
			if (tmp1 != tmp2) {
				
				return (tmp1 > tmp2 ? 1 : -1);
				
			} else {
				
				tmp1 = (n1 >> 8) & 0x000000FF;
				tmp2 = (n2 >> 8) & 0x000000FF;
				
				if (tmp1 != tmp2) {
					
					return (tmp1 > tmp2 ? 1 : -1);
					
				} else {
					
					tmp1 = n1 & 0x000000FF;
					tmp2 = n2 & 0x000000FF;
					
					if (tmp1 != tmp2) {
						
						return (tmp1 > tmp2 ? 1 : -1);
						
					} else {
						
						return 0;
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	public function __updateChildren (transformOnly:Bool):Void {
		
		
		
	}
	
	
}


//private class MinstdGenerator {
	
	/** A MINSTD pseudo-random number generator.
	 *
	 * This generates a pseudo-random number sequence equivalent to std::minstd_rand0 from the C++ standard library, which
	 * is the generator that Flash uses to generate noise for BitmapData.noise().
	 *
	 * MINSTD was originally suggested in "A pseudo-random number generator for the System/360", P.A. Lewis, A.S. Goodman,
	 * J.M. Miller, IBM Systems Journal, Vol. 8, No. 2, 1969, pp. 136-146 */
	
	/*private static inline var a = 16807;
	private static inline var m = (1 << 31) - 1;

	private var value:Int;
	

	public function new (seed:Int) {
		
		if (seed == 0) {
			
			this.value = 1;
			
		} else {
			
			this.value = seed;
			
		}
		
	}
	
	
	public function nextValue():Int {
		
		var lo = a * (value & 0xffff);
		var hi = a * (value >>> 16);
		lo += (hi & 0x7fff) << 16;
		
		if (lo < 0 || lo > m) {
			
			lo &= m;
			++lo;
			
		}
		
		lo += hi >>> 15;
		
		if (lo < 0 || lo > m) {
			
			lo &= m;
			++lo;
			
		}
		
		return value = lo;
		
	}
	
	
}*/


#else
typedef BitmapData = flash.display.BitmapData;
#end