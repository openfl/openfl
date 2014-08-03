package openfl.display; #if !flash


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.utils.ImageCanvasUtil;
import lime.math.ColorMatrix;
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
import js.html.ImageData;
import js.html.ImageElement;
import js.html.Uint8ClampedArray;
import js.Browser;
#end

@:access(lime.graphics.Image)
@:access(lime.graphics.ImageBuffer)
@:access(lime.math.Rectangle)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)


@:autoBuild(openfl.Assets.embedBitmap())
class BitmapData implements IBitmapDrawable {
	
	
	public var height (default, null):Int;
	public var rect (default, null):Rectangle;
	public var transparent (default, null):Bool;
	public var width (default, null):Int;
	
	public var __worldTransform:Matrix;
	
	private var __buffer:GLBuffer;
	private var __image:Image;
	private var __isValid:Bool;
	private var __texture:GLTexture;
	private var __uvData:TextureUvs;
	
	
	public function new (width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF) {
		
		this.transparent = transparent;
		
		if (width > 0 && height > 0) {
			
			this.width = width;
			this.height = height;
			rect = new Rectangle (0, 0, width, height);
			
			if (!transparent) {
				
				fillColor = (0xFF << 24) | (fillColor & 0xFFFFFF);
				
			}
			
			__image = new Image (null, 0, 0, width, height, fillColor);
			__isValid = true;
			
		}
		
		__createUVs ();
		
	}
	
	
	public function applyFilter (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {
		
		if (!__isValid || sourceBitmapData == null || !sourceBitmapData.__isValid) return;
		
		#if js
		ImageCanvasUtil.convertToCanvas (__image);
		ImageCanvasUtil.convertToCanvas (__image);
		ImageCanvasUtil.convertToCanvas (sourceBitmapData.__image);
		ImageCanvasUtil.convertToCanvas (sourceBitmapData.__image);
		#end
		
		#if js
		filter.__applyFilter (cast __image.buffer.data, cast sourceBitmapData.__image.buffer.data, sourceRect, destPoint);
		#end
		
		__image.dirty = true;
		
	}
	
	
	public function clone ():BitmapData {
		
		if (!__isValid) {
			
			return new BitmapData (width, height, transparent);
			
		} else {
			
			return BitmapData.fromImage (__image.clone (), transparent);
			
		}
		
	}
	
	
	public function colorTransform (rect:Rectangle, colorTransform:ColorTransform):Void {
		
		__image.colorTransform (rect.__toLimeRectangle (), colorTransform.__toLimeColorMatrix ());
		
	}
	
	
	public function copyChannel (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:Int, destChannel:Int):Void {
		
		if (!__isValid) return;
		
		var sourceChannel = switch (sourceChannel) {
			
			case 1: ImageChannel.RED;
			case 2: ImageChannel.GREEN;
			case 4: ImageChannel.BLUE;
			case 8: ImageChannel.ALPHA;
			default: return;
			
		}
		
		var destChannel = switch (destChannel) {
			
			case 1: ImageChannel.RED;
			case 2: ImageChannel.GREEN;
			case 4: ImageChannel.BLUE;
			case 8: ImageChannel.ALPHA;
			default: return;
			
		}
		
		__image.copyChannel (sourceBitmapData.__image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), sourceChannel, destChannel);
		
	}
	
	
	public function copyPixels (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void {
		
		if (!__isValid || sourceBitmapData == null) return;
		
		__image.copyPixels (sourceBitmapData.__image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), alphaBitmapData != null ? alphaBitmapData.__image : null, alphaPoint != null ? alphaPoint.__toLimeVector2 () : null, mergeAlpha);
		
	}
	
	
	public function dispose ():Void {
		
		__image = null;
		
		width = 0;
		height = 0;
		rect = null;
		__isValid = false;
		
	}
	
	
	public function draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		if (!__isValid) return;
		
		switch (__image.type) {
			
			case CANVAS:
				
				ImageCanvasUtil.convertToCanvas (__image);
				ImageCanvasUtil.sync (__image);
				
				#if js
				var buffer = __image.buffer;
				
				var renderSession = new RenderSession ();
				renderSession.context = buffer.__srcContext;
				renderSession.roundPixels = true;
				
				if (!smoothing) {
					
					untyped (buffer.__srcContext).mozImageSmoothingEnabled = false;
					untyped (buffer.__srcContext).webkitImageSmoothingEnabled = false;
					buffer.__srcContext.imageSmoothingEnabled = false;
					
				}
				
				var matrixCache = source.__worldTransform;
				source.__worldTransform = matrix != null ? matrix : new Matrix ();
				source.__updateChildren (false);
				source.__renderCanvas (renderSession);
				source.__worldTransform = matrixCache;
				source.__updateChildren (true);
				
				if (!smoothing) {
					
					untyped (buffer.__srcContext).mozImageSmoothingEnabled = true;
					untyped (buffer.__srcContext).webkitImageSmoothingEnabled = true;
					buffer.__srcContext.imageSmoothingEnabled = true;
					
				}
				
				buffer.__srcContext.setTransform (1, 0, 0, 1, 0, 0);
				#end
				
			default:
				
				// TODO
			
		}
		
	}
	
	
	public function encode (rect:Rectangle, compressor:Dynamic, byteArray:ByteArray = null):ByteArray {
		
		openfl.Lib.notImplemented ("BitmapData.encode");
		return null;
		
	}
	
	
	public function fillRect (rect:Rectangle, color:Int):Void {
		
		if (!__isValid || rect == null) return;
		__image.fillRect (rect.__toLimeRectangle (), color);
		
	}
	
	
	public function floodFill (x:Int, y:Int, color:Int):Void {
		
		if (!__isValid) return;
		__image.floodFill (x, y, color);
		
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
	
	
	#if js
	public static function fromCanvas (canvas:CanvasElement, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		bitmapData.width = canvas.width;
		bitmapData.height = canvas.height;
		bitmapData.rect = new Rectangle (0, 0, canvas.width, canvas.height);
		var buffer = new ImageBuffer (null, canvas.width, canvas.height);
		buffer.__srcCanvas = canvas;
		bitmapData.__image = new Image (buffer);
		//bitmapData.__createCanvas (canvas.width, canvas.height);
		//bitmapData.__sourceContext.drawImage (canvas, 0, 0);
		return bitmapData;
		
	}
	#end
	
	
	public static function fromFile (path:String, onload:BitmapData -> Void = null, onerror:Void -> Void = null):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		bitmapData.__loadFromFile (path, onload, onerror);
		return bitmapData;
		
	}
	
	
	public static function fromImage (image:Image, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		bitmapData.__loadFromImage (image);
		return bitmapData;
		
	}
	
	
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
		
		return __image.rect.__toFlashRectangle ();
		
	}
	
	
	public function getPixel (x:Int, y:Int):Int {
		
		if (!__isValid) return 0;
		return __image.getPixel (x, y);
		
	}
	
	
	public function getPixel32 (x:Int, y:Int):Int {
		
		if (!__isValid) return 0;
		return __image.getPixel32 (x, y);
		
	}
	
	
	public function getPixels (rect:Rectangle):ByteArray {
		
		if (!__isValid) return null;
		
		#if js
		ImageCanvasUtil.convertToCanvas (__image);
		ImageCanvasUtil.createImageData (__image);
		#end
		
		var byteArray = new ByteArray ();
		
		if ((rect == null || rect.equals (this.rect)) && #if js true #else false #end) {
			
			#if js
			byteArray.length = __image.buffer.data.length;
			byteArray.byteView.set (__image.buffer.data);
			#end
			
		} else { 
			
			var srcData = __image.buffer.data;
			var srcStride = Std.int (__image.buffer.width * 4);
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
			__image.dirty = true;
			
		}
		
		if (__image.dirty) {
			
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			if (!__image.premultiplied) __image.premultiplied = true;
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, __image.data);
			gl.bindTexture (gl.TEXTURE_2D, null);
			__image.dirty = false;
			
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
		
		return false;
		
	}
	
	
	public function lock ():Void {
		
		
		
	}
	
	
	public function noise (randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false):Void {
		
		if (!__isValid) return;
		
		openfl.Lib.notImplemented ("BitmapData.noise");
		
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
		
		if (!__isValid) return;
		__image.setPixel (x, y, color);
		
	}
	
	
	public function setPixel32 (x:Int, y:Int, color:Int):Void {
		
		if (!__isValid) return;
		__image.setPixel32 (x, y, color);
		
	}
	
	
	public function setPixels (rect:Rectangle, byteArray:ByteArray):Void {
		
		rect = __clipRect (rect);
		if (!__isValid || rect == null) return;
		
		#if js
		ImageCanvasUtil.convertToCanvas (__image);
		#end
		
		var len = Math.round (4 * rect.width * rect.height);
		
		if ((rect.x == 0 && rect.y == 0 && rect.width == width && rect.height == height) && #if js true #else false #end) {
			
			#if js
			ImageCanvasUtil.createImageData (__image);
			__image.buffer.data.set (byteArray.byteView);
			__image.dirty = true;
			#else
			//__sourceBytes.set (byteArray.byteView);
			#end
			
		} else {
			
			#if js
			ImageCanvasUtil.createImageData (__image);
			#end
			
			var data = __image.buffer.data;
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
		
		__image.dirty = true;
		
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
	
	
	private static inline function __flipPixel (pixel:Int):Int {
		
		return (pixel & 0xFF) << 24 | (pixel >>  8 & 0xFF) << 16 | (pixel >> 16 & 0xFF) <<  8 | (pixel >> 24 & 0xFF);
		
	}
	
	
	private inline function __loadFromBase64 (base64:String, type:String, ?onload:BitmapData -> Void):Void {
		
		Image.fromBase64 (base64, type, function (image) {
			
			__loadFromImage (image);
			
			if (onload != null) {
				
				onload (this);
				
			}
			
		});
		
	}
	
	
	private inline function __loadFromBytes (bytes:ByteArray, rawAlpha:ByteArray = null, ?onload:BitmapData -> Void):Void {
		
		Image.fromBytes (bytes, function (image) {
			
			__loadFromImage (image);
			
			if (rawAlpha != null) {
				
				#if js
				ImageCanvasUtil.convertToCanvas (__image);
				ImageCanvasUtil.createImageData (__image);
				#end
				
				var data = __image.buffer.data;
				
				for (i in 0...rawAlpha.length) {
					
					data[i * 4 + 3] = rawAlpha.readUnsignedByte ();
					
				}
				
				__image.dirty = true;
				
			}
			
			if (onload != null) {
				
				onload (this);
				
			}
			
		});
		
	}
	
	
	private function __loadFromFile (path:String, onload:BitmapData -> Void, onerror:Void -> Void):Void {
		
		Image.fromFile (path, function (image) {
			
			__loadFromImage (image);
			
			if (onload != null) {
				
				onload (this);
				
			}
			
		}, onerror);
		
	}
	
	
	private function __loadFromImage (image:Image):Void {
		
		__image = image;
		
		width = image.width;
		height = image.height;
		rect = new Rectangle (0, 0, image.width, image.height);
		__isValid = true;
		
	}
	
	
	public function __renderCanvas (renderSession:RenderSession):Void {
		
		#if js
		if (!__isValid) return;
		
		ImageCanvasUtil.sync (__image);
		
		var context = renderSession.context;
		
		if (__worldTransform == null) __worldTransform = new Matrix ();
		
		context.globalAlpha = 1;
		var transform = __worldTransform;
		
		if (renderSession.roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
		context.drawImage (__image.buffer.src, 0, 0);
		#end
		
	}
	
	
	public function __renderMask (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	private function __sync ():Void {
		
		#if js
		ImageCanvasUtil.sync (__image);
		#end
		
	}
	
	
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