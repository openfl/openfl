package openfl.display; #if !flash


import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.GLRenderContext;
import lime.media.Image;
import lime.media.ImageBuffer;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
import openfl._internal.renderer.RenderSession;
import openfl.errors.IOError;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Image in HTMLImage;
import js.html.ImageData;
import js.html.Uint8ClampedArray;
import js.Browser;
#end


@:autoBuild(openfl.Assets.embedBitmap())
class BitmapData implements IBitmapDrawable {
	
	
	private static var __base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	private static var __base64Encoder:BaseCode;
	private static var __clamp:Vector<Int>;
	
	public var height (default, null):Int;
	public var rect (default, null):Rectangle;
	public var transparent (default, null):Bool;
	public var width (default, null):Int;
	
	public var __worldTransform:Matrix;
	
	private var __buffer:GLBuffer;
	private var __dirty:Bool;
	private var __isValid:Bool;
	private var __loading:Bool;
	private var __sourceBytes:UInt8Array;
	private var __texture:GLTexture;
	private var __uvData:TextureUvs;
	
	#if js
	private var __sourceCanvas:CanvasElement;
	private var __sourceContext:CanvasRenderingContext2D;
	private var __sourceImage:HTMLImage;
	private var __sourceImageData:ImageData;
	private var __sourceImageDataChanged:Bool;
	#end
	
	
	public function new (width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF) {
		
		this.transparent = transparent;
		
		if (__clamp == null) {
			
			__clamp = new Vector<Int> (0xFF + 0xFF);
			
			for (i in 0...0xFF) {
				
				__clamp[i] = i;
				
			}
			
			for (i in 255...(0xFF + 0xFF + 1)) {
				
				__clamp[i] = 255;
				
			}
			
		}
		
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
			__isValid = true;
			
		}
		
		__createUVs ();
		
	}
	
	
	public function applyFilter (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {
		
		if (!__isValid || sourceBitmapData == null || !sourceBitmapData.__isValid) return;
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		sourceBitmapData.__convertToCanvas ();
		sourceBitmapData.__createImageData ();
		#end
		
		#if js
		filter.__applyFilter (__sourceImageData, sourceBitmapData.__sourceImageData, sourceRect, destPoint);
		#end
		
		__dirty = true;
		
		#if js
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function clone ():BitmapData {
		
		#if js
		__syncImageData ();
		#end
		
		if (!__isValid) {
			
			return new BitmapData (width, height, transparent);
			
		}
		
		#if js
		if (__sourceImage != null) {
			
			return BitmapData.fromImageBuffer (ImageBuffer.fromImage (__sourceImage), transparent);
			
		} else {
			
			return BitmapData.fromCanvas (__sourceCanvas, transparent);
			
		}
		#else
		return BitmapData.fromImageBuffer (new ImageBuffer (__sourceBytes, width, height), transparent);
		#end
		
	}
	
	
	public function colorTransform (rect:Rectangle, colorTransform:ColorTransform):Void {
		
		// TODO, could we handle this with 'destination-atop' or 'source-atop' composition modes instead?
		
		rect = __clipRect (rect);
		if (!__isValid || rect == null) return;
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		var data = __sourceImageData.data;
		#else
		var data = __sourceBytes;
		#end
		
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
		
		__dirty = true;
		
		#if js
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function copyChannel (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:Int, destChannel:Int):Void {
		
		sourceRect = __clipRect (sourceRect);
		if (!__isValid || sourceRect == null) return;
		
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
		
		#if js
		sourceBitmapData.__convertToCanvas ();
		sourceBitmapData.__createImageData ();
		var srcData = sourceBitmapData.__sourceImageData.data;
		#else
		var srcData = sourceBitmapData.__sourceBytes;
		#end
		
		var srcStride = Std.int (sourceBitmapData.width * 4);
		var srcPosition = Std.int ((sourceRect.x * 4) + (srcStride * sourceRect.y) + srcIdx);
		var srcRowOffset = srcStride - Std.int (4 * sourceRect.width);
		var srcRowEnd = Std.int (4 * (sourceRect.x + sourceRect.width));
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		var destData = __sourceImageData.data;
		#else
		var destData = __sourceBytes;
		#end
		
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
		
		__dirty = true;
		
		#if js
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function copyPixels (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void {
		
		if (!__isValid || sourceBitmapData == null) return;
		
		if (sourceRect.x + sourceRect.width > sourceBitmapData.width) sourceRect.width = sourceBitmapData.width - sourceRect.x;
		if (sourceRect.y + sourceRect.height > sourceBitmapData.height) sourceRect.height = sourceBitmapData.height - sourceRect.y;
		if (sourceRect.width <= 0 || sourceRect.height <= 0) return;
		
		if (alphaBitmapData != null && alphaBitmapData.transparent) {
			
			if (alphaPoint == null) alphaPoint = new Point ();
			
			var tempData = clone ();
			tempData.copyChannel (alphaBitmapData, new Rectangle (alphaPoint.x, alphaPoint.y, sourceRect.width, sourceRect.height), new Point (sourceRect.x, sourceRect.y), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			sourceBitmapData = tempData;
			
		}
		
		#if js
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
		#else
		var rowOffset = Std.int (destPoint.y - sourceRect.y);
		var columnOffset = Std.int (destPoint.x - sourceRect.x);
		
		var sourceData = sourceBitmapData.__sourceBytes;
		var sourceStride = sourceBitmapData.width * 4;
		var sourceOffset:Int;
		
		var data = __sourceBytes;
		var stride = width * 4;
		var offset:Int;
		
		if (!mergeAlpha || !sourceBitmapData.transparent) {
			
			for (row in Std.int (sourceRect.y)...Std.int (sourceRect.height)) {
				
				for (column in Std.int (sourceRect.x)...Std.int (sourceRect.width)) {
					
					sourceOffset = (row * sourceStride) + (column * 4);
					offset = ((row + rowOffset) * stride) + ((column + columnOffset) * 4);
					
					data[offset] = sourceData[sourceOffset];
					data[offset + 1] = sourceData[sourceOffset + 1];
					data[offset + 2] = sourceData[sourceOffset + 2];
					data[offset + 3] = sourceData[sourceOffset + 3];
					
				}
				
			}
			
		} else {
			
			var sourceAlpha:Float;
			var oneMinusSourceAlpha:Float;
			
			for (row in Std.int (sourceRect.y)...Std.int (sourceRect.height)) {
				
				for (column in Std.int (sourceRect.x)...Std.int (sourceRect.width)) {
					
					sourceOffset = (row * sourceStride) + (column * 4);
					offset = ((row + rowOffset) * stride) + ((column + columnOffset) * 4);
					
					sourceAlpha = sourceData[sourceOffset + 3] / 255;
					oneMinusSourceAlpha = (1 - sourceAlpha);
					
					data[offset] = __clamp[Std.int (sourceData[sourceOffset] + (data[offset] * oneMinusSourceAlpha))];
					data[offset + 1] = __clamp[Std.int (sourceData[sourceOffset + 1] + (data[offset + 1] * oneMinusSourceAlpha))];
					data[offset + 2] = __clamp[Std.int (sourceData[sourceOffset + 2] + (data[offset + 2] * oneMinusSourceAlpha))];
					data[offset + 3] = __clamp[Std.int (sourceData[sourceOffset + 3] + (data[offset + 3] * oneMinusSourceAlpha))];
					
				}
				
			}
			
		}
		#end
		
		__dirty = true;
		
	}
	
	
	public function dispose ():Void {
		
		#if js
		__sourceImage = null;
		__sourceCanvas = null;
		__sourceContext = null;
		#else
		__sourceBytes = null;
		#end
		
		width = 0;
		height = 0;
		rect = null;
		__isValid = false;
		__dirty = false;
		
	}
	
	
	public function draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		if (!__isValid) return;
		
		#if js
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
		#else
		// TODO: draw
		#end
		
		__dirty = true;
		
	}
	
	
	public function encode (rect:Rectangle, compressor:Dynamic, byteArray:ByteArray = null):ByteArray {
		
		openfl.Lib.notImplemented ("BitmapData.encode");
		return null;
		
	}
	
	
	public function fillRect (rect:Rectangle, color:Int):Void {
		
		rect = __clipRect (rect);
		if (!__isValid || rect == null) return;
		
		#if js
		__convertToCanvas ();
		__syncImageData ();
		
		if (rect.x == 0 && rect.y == 0 && rect.width == width && rect.height == height) {
			
			if (transparent && ((color & 0xFF000000) == 0)) {
				
				__sourceCanvas.width = width;
				return;
				
			}
			
		}
		#end
		
		__fillRect (rect, color);
		
	}
	
	
	public function floodFill (x:Int, y:Int, color:Int):Void {
		
		if (!__isValid) return;
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		var data = __sourceImageData.data;
		#else
		var data = __sourceBytes;
		#end
		
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
		
		__dirty = true;
		
		#if js
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
		
		#if js
		var bitmapData = new BitmapData (0, 0, true);
		bitmapData.__sourceImage = new HTMLImage ();
		bitmapData.__sourceImage.onload = function (_) {
			
			bitmapData.width = bitmapData.__sourceImage.width;
			bitmapData.height = bitmapData.__sourceImage.height;
			bitmapData.rect = new Rectangle (0, 0, bitmapData.__sourceImage.width, bitmapData.__sourceImage.height);
			bitmapData.__isValid = true;
			
			if (onload != null) {
				
				onload (bitmapData);
				
			}
			
		}
		
		bitmapData.__sourceImage.onerror = function (_) {
			
			bitmapData.__isValid = false;
			if (onfail != null) {
				
				onfail();
				
			}
		}
		
		bitmapData.__sourceImage.src = path;
		
		// Another IE9 bug: loading 20+ images fails unless this line is added.
		// (issue #1019768)
		if (bitmapData.__sourceImage.complete) { }
		return bitmapData;
		#else
		var image = ImageBuffer.fromFile (path);
		return BitmapData.fromImageBuffer (image);
		#end
		
	}
	
	
	public static function fromImage (image:Image, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		#if js
		bitmapData.__sourceImage = image.buffer.src;
		#else
		image.premultiplied = true;
		bitmapData.__sourceBytes = image.buffer.data;
		#end
		bitmapData.width = image.width;
		bitmapData.height = image.height;
		bitmapData.rect = new Rectangle (0, 0, image.width, image.height);
		bitmapData.__isValid = true;
		return bitmapData;
		
	}
	
	
	public static function fromImageBuffer (imageBuffer:ImageBuffer, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		#if js
		bitmapData.__sourceImage = imageBuffer.src;
		#else
		var image = new Image (imageBuffer);
		image.premultiplied = true;
		//image.premultiplyAlpha ();
		bitmapData.__sourceBytes = imageBuffer.data;
		#end
		bitmapData.width = imageBuffer.width;
		bitmapData.height = imageBuffer.height;
		bitmapData.rect = new Rectangle (0, 0, imageBuffer.width, imageBuffer.height);
		bitmapData.__isValid = true;
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
		
		if (!__isValid || x < 0 || y < 0 || x >= width || y >= height) return 0;
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		var data = __sourceImageData.data;
		#else
		var data = __sourceBytes;
		#end
		
		var offset = (4 * y * width + x * 4);
		return (data[offset] << 16) | (data[offset + 1] << 8) | (data[offset + 2]);
		
	}
	
	
	public function getPixel32 (x:Int, y:Int):Int {
		
		if (!__isValid || x < 0 || y < 0 || x >= width || y >= height) return 0;
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		var data = __sourceImageData.data;
		#else
		var data = __sourceBytes;
		#end
		
		var offset = (4 * y * width + x * 4);
		return return (transparent ? data[offset + 3] : 0xFF) << 24 | data[offset] << 16 | data[offset + 1] << 8 | data[offset + 2];
		
	}
	
	
	public function getPixels (rect:Rectangle):ByteArray {
		
		if (!__isValid) return null;
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		#end
		
		var byteArray = new ByteArray ();
		
		if ((rect == null || rect.equals (this.rect)) && #if js true #else false #end) {
			
			#if js
			byteArray.length = __sourceImageData.data.length;
			byteArray.byteView.set (__sourceImageData.data);
			#end
			
		} else { 
			
			#if js
			var srcData = __sourceImageData.data;
			#else
			var srcData = __sourceBytes;
			#end
			
			var srcStride = Std.int (width * 4);
			var srcPosition = Std.int ((rect.x * 4) + (srcStride * rect.y));
			var srcRowOffset = srcStride - Std.int (4 * rect.width);
			var srcRowEnd = Std.int (4 * (rect.x + rect.width));
			
			var length = Std.int (4 * rect.width * rect.height);
			#if js
			byteArray.length = length;
			#end
			
			for (i in 0...length) {
				
				byteArray.__set (i, srcData[srcPosition++]);
				
				if ((srcPosition % srcStride) > srcRowEnd) {
					
					srcPosition += srcRowOffset;
					
				}
				
			}
			
		}
		
		byteArray.position = 0;
		
		return byteArray;
		
	}
	
	
	public function getTexture (gl:GLRenderContext):GLTexture {
		
		if (__texture == null) {
			
			__texture = gl.createTexture ();
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			__dirty = true;
			
		}
		
		if (__dirty) {
			
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			
			#if js
			// TODO: Premultiply the canvas, or modify __sourceBytes directly, to improve performance
			/*__syncImageData ();
			
			if (__sourceImage != null) {
				
				gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, __sourceImage);
				
			} else {
				
				gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, __sourceCanvas);
				
			}*/
			__convertToCanvas ();
			__syncImageData ();
			
			var pixels = __sourceContext.getImageData (0, 0, width, height);
			var buffer = new ImageBuffer (new UInt8Array (pixels.data), width, height);
			var image = new Image (buffer);
			image.premultiplied = true;
			
			__sourceBytes = image.buffer.data;
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, __sourceBytes);
			
			#else
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, __sourceBytes);
			#end
			
			gl.bindTexture (gl.TEXTURE_2D, null);
			__dirty = false;
			
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
		
		if (!__isValid) return false;
		
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
		
		if (!__isValid) return;
		
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
		
		var memory = new ByteArray ();
		var sw:Int = Std.int (sourceRect.width);
		var sh:Int = Std.int (sourceRect.height);
		
		#if js
		memory.length = ((sw * sh) * 4);
		#end
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
		
	}
	
	
	public function perlinNoise (baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7, grayScale:Bool = false, offsets:Array<Point> = null):Void {
		
		openfl.Lib.notImplemented ("BitmapData.perlinNoise");
		
	}
	
	
	public function scroll (x:Int, y:Int):Void {
		
		openfl.Lib.notImplemented ("BitmapData.scroll");
		
	}
	
	
	public function setPixel (x:Int, y:Int, color:Int):Void {
		
		if (!__isValid || x < 0 || y < 0 || x >= width || y >= height) return;
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		var data = __sourceImageData.data;
		#else
		var data = __sourceBytes;
		#end
		
		var offset = (4 * y * width + x * 4);
		
		data[offset] = (color & 0xFF0000) >>> 16;
		data[offset + 1] = (color & 0x00FF00) >>> 8;
		data[offset + 2] = (color & 0x0000FF);
		if (transparent) data[offset + 3] = (0xFF);
		
		__dirty = true;
		
		#if js
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function setPixel32 (x:Int, y:Int, color:Int):Void {
		
		if (!__isValid || x < 0 || y < 0 || x >= width || y >= height) return;
		
		#if js
		__convertToCanvas ();
		__createImageData ();
		var data = __sourceImageData.data;
		#else
		var data = __sourceBytes;
		#end
		
		var offset = (4 * y * width + x * 4);
		
		data[offset] = (color & 0x00FF0000) >>> 16;
		data[offset + 1] = (color & 0x0000FF00) >>> 8;
		data[offset + 2] = (color & 0x000000FF);
		
		if (transparent) {
			
			data[offset + 3] = (color & 0xFF000000) >>> 24;
			
		} else {
			
			data[offset + 3] = (0xFF);
			
		}
		
		__dirty = true;
		
		#if js
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function setPixels (rect:Rectangle, byteArray:ByteArray):Void {
		
		rect = __clipRect (rect);
		if (!__isValid || rect == null) return;
		
		#if js
		__convertToCanvas ();
		#end
		
		var len = Math.round (4 * rect.width * rect.height);
		
		if ((rect.x == 0 && rect.y == 0 && rect.width == width && rect.height == height) && #if js true #else false #end) {
			
			#if js
			if (__sourceImageData == null) {
				
				__sourceImageData = __sourceContext.createImageData (width, height);
				
			}
			
			__sourceImageData.data.set (byteArray.byteView);
			#else
			//__sourceBytes.set (byteArray.byteView);
			#end
			
		} else {
			
			#if js
			__createImageData ();
			var data = __sourceImageData.data;
			#else
			var data = __sourceBytes;
			#end
			
			var offset = Math.round (4 * width * rect.y + rect.x * 4);
			var pos = offset;
			var boundR = Math.round (4 * (rect.x + rect.width));
			
			for (i in 0...len) {
				
				if (((pos) % (width * 4)) > boundR - 1) {
					
					pos += width * 4 - boundR;
					
				}
				
				data[pos] = byteArray.readByte ();
				pos++;
				
			}
			
		}
		
		__dirty = true;
		
		#if js
		__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public function setVector (rect:Rectangle, inputVector:Vector<UInt>) {
		
		var byteArray = new ByteArray ();
		#if js
		byteArray.length = inputVector.length * 4;
		#end
		
		for (color in inputVector) {
			
			byteArray.writeUnsignedInt (color);
			
		}
		
		byteArray.position = 0;
		setPixels (rect, byteArray);
		
	}
	
	
	public function threshold (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000, mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int {
		
		if (sourceBitmapData == this && sourceRect.equals(rect) && destPoint.x == 0 && destPoint.y == 0) {
			
			var hits = 0;
			
			threshold = __flipPixel (threshold);
			color = __flipPixel (color);
			
			var memory = new ByteArray ();
			#if js
			memory.length  = width * height * 4;
			#end
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
			var memory = new ByteArray ();
			#if js
			memory.length = totalMemory;
			#end
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
		
		if (r.x + r.width >= width) {
			
			r.width -= r.x + r.width - width;
			
			if (r.width <= 0) return null;
			
		}
		
		if (r.y + r.height >= height) {
			
			r.height -= r.y + r.height - height;
			
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
			__isValid = true;
			
		}
		
	}
	
	
	private function __createImageData ():Void {
		
		if (__sourceImageData == null) {
			
			__sourceImageData = __sourceContext.getImageData (0, 0, width, height);
			
		}
		
	}
	#end
	
	
	private function __createUVs ():Void {
		
		if (__uvData == null) __uvData = new TextureUvs();
		
		__uvData.x0 = 0;
		__uvData.y0 = 0;
		__uvData.x1 = 1;
		__uvData.y1 = 0;
		__uvData.x2 = 1;
		__uvData.y2 = 1;
		__uvData.x3 = 0;
		__uvData.y3 = 1;
		
	}
	
	
	private function __fillRect (rect:Rectangle, color:Int) {
		
		var a = (transparent) ? ((color & 0xFF000000) >>> 24) : 0xFF;
		var r = (color & 0x00FF0000) >>> 16;
		var g = (color & 0x0000FF00) >>> 8;
		var b = (color & 0x000000FF);
		
		#if js
		__sourceContext.fillStyle = 'rgba(' + r + ', ' + g + ', ' + b + ', ' + (a / 255) + ')';
		__sourceContext.fillRect (rect.x, rect.y, rect.width, rect.height);
		#else
		if (__sourceBytes == null) __sourceBytes = new UInt8Array (rect.width * rect.height * 4);
		var data = __sourceBytes;
		var stride = width * 4;
		var offset:Int;
		
		for (row in Std.int (rect.y)...Std.int (rect.height)) {
			
			for (column in Std.int (rect.x)...Std.int (rect.width)) {
				
				offset = (row * stride) + (column * 4);
				
				data[offset] = r;
				data[offset + 1] = g;
				data[offset + 2] = b;
				data[offset + 3] = a;
				
			}
			
		}
		#end
		
	}
	
	
	private static inline function __flipPixel (pixel:Int):Int {
		
		return (pixel & 0xFF) << 24 | (pixel >>  8 & 0xFF) << 16 | (pixel >> 16 & 0xFF) <<  8 | (pixel >> 24 & 0xFF);
		
	}
	
	
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
			
			__isValid = true;
			
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
		#else
		var image = ImageBuffer.fromBytes (bytes);
		//image.premultiplyAlpha ();
		__sourceBytes = image.data;
		width = image.width;
		height = image.height;
		rect = new Rectangle (0, 0, image.width, image.height);
		__isValid = true;
		#end
		
	}
	
	
	public function __renderCanvas (renderSession:RenderSession):Void {
		
		#if js
		if (!__isValid) return;
		
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
	
	
	private static function __ucompare (n1:Int, n2:Int) : Int {
		
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


class TextureUvs {
	
	
	public var x0:Float = 0;
	public var x1:Float = 0;
	public var x2:Float = 0;
	public var x3:Float = 0;
	public var y0:Float = 0;
	public var y1:Float = 0;
	public var y2:Float = 0;
	public var y3:Float = 0;
	
	
	public function new () {
		
	}
	
	
}


#else
typedef BitmapData = flash.display.BitmapData;
#end