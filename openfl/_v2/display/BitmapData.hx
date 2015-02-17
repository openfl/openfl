package openfl._v2.display; #if lime_legacy


import haxe.io.Bytes;
import openfl.display.JPEGEncoderOptions;
import openfl.display.PNGEncoderOptions;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Lib;


@:autoBuild(openfl._v2.Assets.embedBitmap())
class BitmapData implements IBitmapDrawable {
	
	
	@:deprecated public inline static var CLEAR = 0x00000000;
	@:deprecated public inline static var BLACK = 0xFF000000;
	@:deprecated public inline static var WHITE = 0xFF000000;
	@:deprecated public inline static var RED = 0xFFFF0000;
	@:deprecated public inline static var GREEN = 0xFF00FF00;
	@:deprecated public inline static var BLUE = 0xFF0000FF;
	@:deprecated public inline static var PNG = "png";
	@:deprecated public inline static var JPG = "jpg";
	public inline static var TRANSPARENT = 0x0001;
	public inline static var HARDWARE = 0x0002;
	public inline static var FORMAT_8888 = 0;
	public inline static var FORMAT_4444 = 1; //16 bit with alpha channel
	public inline static var FORMAT_565 = 2;  //16 bit 565 without alpha
		
	public var height (get, null):Int;
	public var premultipliedAlpha (get, set):Bool;
	public var rect (get, null):Rectangle;
	public var transparent (get, null):Bool;
	public var width (get, null):Int;
	
	@:noCompletion public var __handle:Dynamic;
	@:noCompletion private var __transparent:Bool;
	
	
	public function new (width:Int, height:Int, transparent:Bool = true, fillColor:Int = 0xFFFFFFFF, gpuMode:Null<Int> = null) {
		
		__transparent = transparent;
		
		if (width < 1 || height < 1) {
			
			__handle = null;
			
		} else {
			
			var flags = HARDWARE;
			if (transparent) flags |= TRANSPARENT;
			var alpha = fillColor >>> 24;
			
			if (transparent && alpha == 0) {
				
				fillColor = 0;
				
			}
			
			__handle = lime_bitmap_data_create (width, height, flags, fillColor & 0xFFFFFF, alpha, gpuMode);
			
		}
		
	}
	
	
	public function applyFilter (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {
		
		lime_bitmap_data_apply_filter (__handle, sourceBitmapData.__handle, sourceRect, destPoint, filter);
		
	}
	
	
	public function clear (color:Int):Void {
		
		lime_bitmap_data_clear (__handle, color);
		
	}
	
	
	public function clone ():BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		bitmapData.__handle = lime_bitmap_data_clone (__handle);
		return bitmapData;
		
	}
	
	
	public function colorTransform (rect:Rectangle, colorTransform:ColorTransform):Void {
		
		lime_bitmap_data_color_transform (__handle, rect, colorTransform);
		
	}
	
	
	public function copyChannel (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:Int, destChannel:Int):Void {
		
		lime_bitmap_data_copy_channel (sourceBitmapData.__handle, sourceRect, __handle, destPoint, sourceChannel, destChannel);
		
	}
	
	
	public function copyPixels (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void {
		
		lime_bitmap_data_copy (sourceBitmapData.__handle, sourceRect, __handle, destPoint, mergeAlpha);
		
	}
	
	
	@:deprecated public static inline function createColor (rgb:Int, alpha:Int = 0xFF):Int {
		
		return rgb | (alpha << 24);
		
	}
	
	
	#if cpp
	public function createHardwareSurface ():Void {
		
		lime_bitmap_data_create_hardware_surface (__handle);
		
	}
	
	
	public function destroyHardwareSurface ():Void {
		
		lime_bitmap_data_destroy_hardware_surface (__handle);
		
	}
	#end
	
	
	public function dispose ():Void {
		
		if (__handle != null) {
			
			lime_bitmap_data_dispose (__handle);
			
		}
		
		__handle = null;
		
	}
	
	
	public function draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		source.__drawToSurface (__handle, matrix, colorTransform, Std.string (blendMode), clipRect, smoothing);
		
	}
	
	
	public function dumpBits ():Void {
		
		lime_bitmap_data_dump_bits (__handle);
		
	}
	
	
	public function encode (rectOrFormat:Dynamic, compressorOrQuality:Dynamic = 0.9, byteArray:ByteArray = null):ByteArray {
		
		// TODO: Support rect
		// COMPATIBILITY: Support older "encode ('jpg', 0.9)" format as well
		
		if (Std.is (rectOrFormat, String)) {
			
			var format:String = cast rectOrFormat;
			var quality = cast (compressorOrQuality, Float);
			
			return lime_bitmap_data_encode (__handle, format, quality);
			
		} else {
			
			if (rectOrFormat == null) return byteArray = null;
			
			if (Std.is (compressorOrQuality, PNGEncoderOptions)) {
				
				return byteArray = lime_bitmap_data_encode (__handle, "png", 0);
				
			} else if (Std.is (compressorOrQuality, JPEGEncoderOptions)) {
				
				return byteArray = lime_bitmap_data_encode (__handle, "jpg", cast (compressorOrQuality, JPEGEncoderOptions).quality / 100);
				
			}
			
			return byteArray = null;
			
		}
		
	}
	
	
	@:deprecated public static inline function extractAlpha (argb:Int):Int {
		
		return argb >>> 24;
		
	}
	
	
	@:deprecated public static inline function extractColor (argb:Int):Int {
		
		return argb & 0xFFFFFF;
		
	}
	
	
	public function fillRect (rect:Rectangle, color:Int):Void {
		
		lime_bitmap_data_fill (__handle, rect, color & 0xFFFFFF, color >>> 24);
		
	}
	
	
	public function fillRectEx (rect:Rectangle, color:Int, alpha:Int = 0xFF):Void {
		
		lime_bitmap_data_fill (__handle, rect, color, alpha);
		
	}
	
	
	public function floodFill (x:Int, y:Int, color:Int):Void {
		
		lime_bitmap_data_flood_fill (__handle, x, y, color);
		
	}
	
	
	public function generateFilterRect (sourceRect:Rectangle, filter:BitmapFilter):Rectangle {
		
		var result = new Rectangle ();
		lime_bitmap_data_generate_filter_rect (sourceRect, filter, result);
		return result;
		
	}
	
	
	public function getColorBoundsRect (mask:Int, color:Int, findColor:Bool = true):Rectangle {
		
		var result = new Rectangle ();
		lime_bitmap_data_get_color_bounds_rect (__handle, mask, color, findColor, result);
		return result;
		
	}
	
	
	public function getPixel (x:Int, y:Int):Int {
		
		return lime_bitmap_data_get_pixel (__handle, x, y);
		
	}
	
	
	public function getPixel32 (x:Int, y:Int):Int {
		
		#if neko
		if (transparent) {
			
			var pixels = getPixels (new Rectangle (x, y, 1, 1));
			pixels.position = 0;
			return pixels.readUnsignedInt ();
			
		}
		#end
		
		return lime_bitmap_data_get_pixel32 (__handle, x, y);
		
	}
	
	
	public function getPixels (rect:Rectangle):ByteArray {
		
		var result:ByteArray = lime_bitmap_data_get_pixels (__handle, rect);
		if (result != null) result.position = result.length;
		return result;
		
	}
	
	
	public inline static function getRGBAPixels (bitmapData:BitmapData):ByteArray {
		
		var data = bitmapData.getPixels (new Rectangle (0, 0, bitmapData.width, bitmapData.height));
		var size = bitmapData.width * bitmapData.height;
		var v;
		
		data.position = 0;
		
		for (i in 0...size) {
			
			v = data.readInt ();
			data.position = i << 2;
			data.writeInt ((((v >>> 0) & 0xFF) << 8) | (((v >>> 8) & 0xFF) << 16) | (((v >>> 16) & 0xFF) << 24) | (((v >>> 24) & 0xFF) << 0));
			
		}
		
		return data;
		
	}
	
	
	public function getVector (rect:Rectangle):Array<Int> {
		
		var pixels = Std.int (rect.width * rect.height);
		if (pixels < 1) return [];
		
		var result = new Array<Int> ();
		result[pixels - 1] = 0;
		
		#if cpp
		lime_bitmap_data_get_array (__handle, rect, result);
		#else
		var bytes:ByteArray = lime_bitmap_data_get_pixels (__handle, rect);
		bytes.position = 0;
		for (i in 0...pixels) result[i] = bytes.readInt ();
		#end
		
		return result;
		
	}
	
	
	public static function load (filename:String, format:Int = 0):BitmapData {
		
		var result = new BitmapData (0, 0);
		result.__handle = lime_bitmap_data_load (filename, format);
		return result;
		
	}
	
	
	public static function loadFromBytes (bytes:ByteArray, rawAlpha:ByteArray = null):BitmapData {
		
		var result = new BitmapData (0, 0, true);
		result.__loadFromBytes (bytes, rawAlpha);
		return result;
		
	}
	
	
	public static function loadFromHaxeBytes (bytes:Bytes, rawAlpha:Bytes = null):BitmapData {
		
		return loadFromBytes (ByteArray.fromBytes (bytes), rawAlpha == null ? null : ByteArray.fromBytes (rawAlpha));
		
	}
	
	
	public function lock ():Void {
		
		// Handled internally...
		
	}
	
	
	public function merge (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt, alphaMultiplier:UInt):Void {
		
		if (sourceBitmapData == null) return;
		
		var sw:Int = Std.int (sourceRect.width);
		var sh:Int = Std.int (sourceRect.height);
		
		var sourcePixels = sourceBitmapData.getPixels (sourceRect);
		if (sourcePixels == null) return;
		sourcePixels.position = 0;
		
		var destRect = new Rectangle (destPoint.x, destPoint.y, sw, sh);
		var destPixels = getPixels (destRect);
		if (destPixels == null) return;
		destPixels.position = 0;
		
		var sourcePixel:Int, destPixel:Int, r:Int, g:Int, b:Int, a:Int, color:Int, c1:Int, c2:Int, c3:Int, c4:Int;
		
		for (i in 0...(sh * sw)) {
			
			sourcePixel = sourcePixels.readUnsignedInt ();
			destPixel = destPixels.readUnsignedInt ();
			
			a = Std.int (((((sourcePixel >> 24) & 0xFF) * redMultiplier) + (((destPixel >> 24) & 0xFF) * (256 - redMultiplier))) / 256);
			r = Std.int (((((sourcePixel >> 16) & 0xFF) * redMultiplier) + (((destPixel >> 16) & 0xFF) * (256 - redMultiplier))) / 256);
			g = Std.int (((((sourcePixel >> 8) & 0xFF) * redMultiplier) + (((destPixel >> 8) & 0xFF) * (256 - redMultiplier))) / 256);
			b = Std.int ((((sourcePixel & 0xFF) * redMultiplier) + ((destPixel & 0xFF) * (256 - redMultiplier))) / 256);
			
			if (a > 255 || r > 255 || g > 255 || b > 255) {
				
				trace (a + ", " + r + ", " + g + ", " + b);
				
			}
			
			color = a << 24 | r << 16 | g << 8 | b;
			
			destPixels.position = i * 4;
			destPixels.writeUnsignedInt (color);
			
		}
		
		destPixels.position = 0;
		setPixels (destRect, destPixels);
		
	}
	
	
	public function multiplyAlpha ():Void {
		
		lime_bitmap_data_multiply_alpha (__handle);
		
	}
	
	
	public function noise (randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false):Void {
		
		lime_bitmap_data_noise (__handle, randomSeed, low, high, channelOptions, grayScale);
		
	}
	
	
	public function paletteMap (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redArray:Array<Int> = null, greenArray:Array<Int> = null, blueArray:Array<Int> = null, alphaArray:Array<Int> = null):Void {
		
		var sw:Int = Std.int (sourceRect.width);
		var sh:Int = Std.int (sourceRect.height);
		
		var pixels = sourceBitmapData.getPixels (sourceRect);
		pixels.position = 0;
		
		var pixelValue:Int, r:Int, g:Int, b:Int, a:Int, color:Int, c1:Int, c2:Int, c3:Int, c4:Int;
		
		for (i in 0...(sh * sw)) {
			
			pixelValue = pixels.readUnsignedInt ();
			
			c1 = (alphaArray == null) ? pixelValue & 0xFF000000 : alphaArray[(pixelValue >> 24) & 0xFF];
			c2 = (redArray == null) ? pixelValue & 0x00FF0000 : redArray[(pixelValue >> 16) & 0xFF];
			c3 = (greenArray == null) ? pixelValue & 0x0000FF00 : greenArray[(pixelValue >> 8) & 0xFF];
			c4 = (blueArray == null) ? pixelValue & 0x000000FF : blueArray[(pixelValue) & 0xFF];
			
			a = ((c1 >> 24) & 0xFF) + ((c2 >> 24) & 0xFF) + ((c3 >> 24) & 0xFF) + ((c4 >> 24) & 0xFF);
			if (a > 0xFF) a == 0xFF;
			
			r = ((c1 >> 16) & 0xFF) + ((c2 >> 16) & 0xFF) + ((c3 >> 16) & 0xFF) + ((c4 >> 16) & 0xFF);
			if (r > 0xFF) r == 0xFF;
			
			g = ((c1 >> 8) & 0xFF) + ((c2 >> 8) & 0xFF) + ((c3 >> 8) & 0xFF) + ((c4 >> 8) & 0xFF);
			if (g > 0xFF) g == 0xFF;
			
			b = ((c1) & 0xFF) + ((c2) & 0xFF) + ((c3) & 0xFF) + ((c4) & 0xFF);
			if (b > 0xFF) b == 0xFF;
			
			color = a << 24 | r << 16 | g << 8 | b;
			
			pixels.position = i * 4;
			pixels.writeUnsignedInt (color);
			
		}
		
		pixels.position = 0;
		var destRect = new Rectangle (destPoint.x, destPoint.y, sw, sh);
		setPixels (destRect, pixels);
		
	}
	

	public function perlinNoise (baseX:Float, baseY:Float, numOctaves:Int, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:Int = 7, grayScale:Bool = false, ?offsets:Array<Point>):Void {
		
		var perlin = new OptimizedPerlin (randomSeed, numOctaves);
		perlin.fill (this, baseX, baseY, 0);
		
	}
	
	
	@:deprecated private static inline function sameValue (a:Int, b:Int):Bool {
		
		return a == b;
		
	}
	
	
	public function scroll (x:Int, y:Int):Void {
		
		lime_bitmap_data_scroll (__handle, x, y);
		
	}
	
	
	public function setFlags (flags:Int):Void {
		
		// Used for optimization
		lime_bitmap_data_set_flags (__handle, flags);
		
	}
	
	
	public function setFormat (format:Int):Void {
		
		lime_bitmap_data_set_format (__handle, format);
		
	}
	
	
	public function setPixel (x:Int, y:Int, color:Int):Void {
		
		lime_bitmap_data_set_pixel (__handle, x, y, color);
		
	}
	
	
	public function setPixel32 (x:Int, y:Int, color:Int):Void {
		
		lime_bitmap_data_set_pixel32 (__handle, x, y, color);
		
	}
	
	
	public function setPixels (rect:Rectangle, pixels:ByteArray):Void {
		
		var size = Std.int (rect.width * rect.height * 4);
		pixels.checkData (Std.int (size));
		lime_bitmap_data_set_bytes (__handle, rect, pixels, pixels.position);
		pixels.position += size;
		
	}
	
	
	public function setVector (rect:Rectangle, pixels:Array<Int>):Void {
		
		var count = Std.int (rect.width * rect.height);
		if (pixels.length < count) return;
		
		#if cpp
		lime_bitmap_data_set_array (__handle, rect, pixels);
		#else
		var bytes = new ByteArray ();
		
		for (i in 0...count) {
			
			bytes.writeInt (pixels[i]);
			
		}
		
		lime_bitmap_data_set_bytes (__handle, rect, bytes, 0);
		#end
		
	}
	
	
	public function threshold (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000, mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int {
		
		if (sourceBitmapData == this && sourceRect.equals(rect) && destPoint.x == 0 && destPoint.y == 0) {
			
			var hits = 0;
			
			threshold = __flipPixel (threshold);
			color = __flipPixel (color);
			
			var memory = new ByteArray ();
			memory.setLength ((width * height) * 4);
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
			memory.setLength (totalMemory);
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
		
		// Handled internally...
		
	}
	
	
	public function unmultiplyAlpha ():Void {
		
		lime_bitmap_data_unmultiply_alpha (__handle);
		
	}
	
	
	@:noCompletion public function __drawToSurface (surface:Dynamic, matrix:Matrix, colorTransform:ColorTransform, blendMode:String, clipRect:Rectangle, smoothing:Bool):Void {
		
		lime_render_surface_to_surface (surface, __handle, matrix, colorTransform, blendMode, clipRect, smoothing);
		
	}
	
	
	@:noCompletion private static inline function __flipPixel (pixel:Int):Int {
		
		return (pixel & 0xFF) << 24 | (pixel >>  8 & 0xFF) << 16 | (pixel >> 16 & 0xFF) <<  8 | (pixel >> 24 & 0xFF);
		
	}
	
	
	@:noCompletion private inline function __loadFromBytes (bytes:ByteArray, rawAlpha:ByteArray = null):Void {
		
		__handle = lime_bitmap_data_from_bytes (bytes, rawAlpha);
		
	}
	
	
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
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_premultipliedAlpha ():Bool { return lime_bitmap_data_get_prem_alpha (__handle); }
	private function set_premultipliedAlpha (value:Bool):Bool { lime_bitmap_data_set_prem_alpha (__handle, value); return value; }
	private function get_rect ():Rectangle { return new Rectangle (0, 0, width, height); }
	private function get_width ():Int { return lime_bitmap_data_width (__handle); }
	private function get_height ():Int { return lime_bitmap_data_height (__handle); }
	private function get_transparent ():Bool { return __transparent; }
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_bitmap_data_create = Lib.load ("lime", "lime_bitmap_data_create", -1);
	private static var lime_bitmap_data_load = Lib.load ("lime", "lime_bitmap_data_load", 2);
	private static var lime_bitmap_data_from_bytes = Lib.load ("lime", "lime_bitmap_data_from_bytes", 2);
	private static var lime_bitmap_data_clear = Lib.load ("lime", "lime_bitmap_data_clear", 2);
	private static var lime_bitmap_data_clone = Lib.load ("lime", "lime_bitmap_data_clone", 1);
	private static var lime_bitmap_data_apply_filter = Lib.load ("lime", "lime_bitmap_data_apply_filter", 5);
	private static var lime_bitmap_data_color_transform = Lib.load ("lime", "lime_bitmap_data_color_transform", 3);
	private static var lime_bitmap_data_copy = Lib.load ("lime", "lime_bitmap_data_copy", 5);
	private static var lime_bitmap_data_copy_channel = Lib.load ("lime", "lime_bitmap_data_copy_channel", -1);
	private static var lime_bitmap_data_fill = Lib.load ("lime", "lime_bitmap_data_fill", 4);
	private static var lime_bitmap_data_get_pixels = Lib.load ("lime", "lime_bitmap_data_get_pixels", 2);
	private static var lime_bitmap_data_get_pixel = Lib.load ("lime", "lime_bitmap_data_get_pixel", 3);
	private static var lime_bitmap_data_get_pixel32 = Lib.load ("lime", "lime_bitmap_data_get_pixel32", 3);
	private static var lime_bitmap_data_get_pixel_rgba = Lib.load ("lime", "lime_bitmap_data_get_pixel_rgba", 3);
	#if cpp
	private static var lime_bitmap_data_get_array = Lib.load ("lime", "lime_bitmap_data_get_array", 3);
	#end
	private static var lime_bitmap_data_get_color_bounds_rect = Lib.load ("lime", "lime_bitmap_data_get_color_bounds_rect", 5);
	private static var lime_bitmap_data_scroll = Lib.load ("lime", "lime_bitmap_data_scroll", 3);
	private static var lime_bitmap_data_set_pixel = Lib.load ("lime", "lime_bitmap_data_set_pixel", 4);
	private static var lime_bitmap_data_set_pixel32 = Lib.load ("lime", "lime_bitmap_data_set_pixel32", 4);
	private static var lime_bitmap_data_set_pixel_rgba = Lib.load ("lime", "lime_bitmap_data_set_pixel_rgba", 4);
	private static var lime_bitmap_data_set_bytes = Lib.load ("lime", "lime_bitmap_data_set_bytes", 4);
	private static var lime_bitmap_data_set_format = Lib.load ("lime", "lime_bitmap_data_set_format", 2);
	#if cpp
	private static var lime_bitmap_data_set_array = Lib.load ("lime", "lime_bitmap_data_set_array", 3);
	private static var lime_bitmap_data_create_hardware_surface = Lib.load ("lime", "lime_bitmap_data_create_hardware_surface", 1);
	private static var lime_bitmap_data_destroy_hardware_surface = Lib.load ("lime", "lime_bitmap_data_destroy_hardware_surface", 1);
	#end
	private static var lime_bitmap_data_dispose = Lib.load ("lime", "lime_bitmap_data_dispose", 1);
	private static var lime_bitmap_data_generate_filter_rect = Lib.load ("lime", "lime_bitmap_data_generate_filter_rect", 3);
	private static var lime_render_surface_to_surface = Lib.load ("lime", "lime_render_surface_to_surface", -1);
	private static var lime_bitmap_data_height = Lib.load ("lime", "lime_bitmap_data_height", 1);
	private static var lime_bitmap_data_width = Lib.load ("lime", "lime_bitmap_data_width", 1);
	private static var lime_bitmap_data_get_transparent = Lib.load ("lime", "lime_bitmap_data_get_transparent", 1);
	private static var lime_bitmap_data_set_flags = Lib.load ("lime", "lime_bitmap_data_set_flags", 2);
	private static var lime_bitmap_data_encode = Lib.load ("lime", "lime_bitmap_data_encode", 3);
	private static var lime_bitmap_data_dump_bits = Lib.load ("lime", "lime_bitmap_data_dump_bits", 1);
	private static var lime_bitmap_data_flood_fill = Lib.load ("lime", "lime_bitmap_data_flood_fill", 4);
	private static var lime_bitmap_data_noise = Lib.load ("lime", "lime_bitmap_data_noise", -1);
	private static var lime_bitmap_data_unmultiply_alpha = Lib.load ("lime", "lime_bitmap_data_unmultiply_alpha", 1);
	private static var lime_bitmap_data_multiply_alpha = Lib.load ("lime", "lime_bitmap_data_multiply_alpha", 1);
	private static var lime_bitmap_data_get_prem_alpha = Lib.load ("lime", "lime_bitmap_data_get_prem_alpha", 1);
	private static var lime_bitmap_data_set_prem_alpha = Lib.load ("lime", "lime_bitmap_data_set_prem_alpha", 2);
	
}


class OptimizedPerlin {
	
	
	private static var P = [
		151,160,137,91,90,15,131,13,201,95,
		96,53,194,233,7,225,140,36,103,30,69,
		142,8,99,37,240,21,10,23,190,6,148,
		247,120,234,75,0,26,197,62,94,252,
		219,203,117,35,11,32,57,177,33,88,
		237,149,56,87,174,20,125,136,171,
		168,68,175,74,165,71,134,139,48,27,
		166,77,146,158,231,83,111,229,122,
		60,211,133,230,220,105,92,41,55,46,
		245,40,244,102,143,54,65,25,63,161,
		1,216,80,73,209,76,132,187,208,89,
		18,169,200,196,135,130,116,188,159,
		86,164,100,109,198,173,186,3,64,52,
		217,226,250,124,123,5,202,38,147,118,
		126,255,82,85,212,207,206,59,227,47,
		16,58,17,182,189,28,42,223,183,170,
		213,119,248,152,2,44,154,163,70,221,
		153,101,155,167,43,172,9,129,22,39,
		253,19,98,108,110,79,113,224,232,
		178,185,112,104,218,246,97,228,251,
		34,242,193,238,210,144,12,191,179,
		162,241,81,51,145,235,249,14,239,
		107,49,192,214,31,181,199,106,157,
		184,84,204,176,115,121,50,45,127,4,
		150,254,138,236,205,93,222,114,67,29,
		24,72,243,141,128,195,78,66,215,61,
		156,180,151,160,137,91,90,15,131,13,
		201,95,96,53,194,233,7,225,140,36,
		103,30,69,142,8,99,37,240,21,10,23,
		190,6,148,247,120,234,75,0,26,197,
		62,94,252,219,203,117,35,11,32,57,
		177,33,88,237,149,56,87,174,20,125,
		136,171,168,68,175,74,165,71,134,139,
		48,27,166,77,146,158,231,83,111,229,
		122,60,211,133,230,220,105,92,41,55,
		46,245,40,244,102,143,54,65,25,63,
		161,1,216,80,73,209,76,132,187,208,
		89,18,169,200,196,135,130,116,188,
		159,86,164,100,109,198,173,186,3,64,
		52,217,226,250,124,123,5,202,38,147,
		118,126,255,82,85,212,207,206,59,
		227,47,16,58,17,182,189,28,42,223,
		183,170,213,119,248,152,2,44,154,
		163,70,221,153,101,155,167,43,172,9,
		129,22,39,253,19,98,108,110,79,113,
		224,232,178,185,112,104,218,246,97,
		228,251,34,242,193,238,210,144,12,
		191,179,162,241,81,51,145,235,249,
		14,239,107,49,192,214,31,181,199,
		106,157,184,84,204,176,115,121,50,
		45,127,4,150,254,138,236,205,93,
		222,114,67,29,24,72,243,141,128,
		195,78,66,215,61,156,180
	];

	private var octaves:Int;

	private var aOctFreq:Array<Float>; // frequency per octave
	private var aOctPers:Array<Float>; // persistence per octave
	private var fPersMax:Float;// 1 / max persistence

	private var iXoffset:Float;
	private var iYoffset:Float;
	private var iZoffset:Float;

	private var baseFactor:Float;
	
	
	public function new (seed = 123, numOctaves = 4, falloff = 0.5) {
		
		baseFactor = 1 / 64;
		octaves = numOctaves;
		seedOffset (seed);
		octFreqPers (falloff);
		
	}
	
	
	public function fill (bitmap:BitmapData, _x:Float, _y:Float, _z:Float, ?_):Void {
		
		var baseX:Float;
		
		baseX = _x * baseFactor + iXoffset;
		_y = _y * baseFactor + iYoffset;
		_z = _z * baseFactor + iZoffset;
		
		var width:Int = bitmap.width;
		var height:Int = bitmap.height;
		
		var p = P;
		var octaves = octaves;
		var aOctFreq = aOctFreq;
		var aOctPers = aOctPers;
		
		var s, fFreq, fPers, x, y, z, xf, yf, zf, X, Y, Z, u, v, w, A, AA, AB, B, BA, BB, x1, y1, z1, hash, g1, g2, g3, g4, g5, g6, g7, g8, color, pixel;
		
		for (py in 0...height) {
			
			_x = baseX;
			
			for (px in 0...width) {
				
				s = 0.;
				
				for (i in 0...octaves) {
					
					fFreq = aOctFreq[i];
					fPers = aOctPers[i];
					
					x = _x * fFreq;
					y = _y * fFreq;
					z = _z * fFreq;
					
					xf = x - (x % 1);
					yf = y - (y % 1);
					zf = z - (z % 1);
					
					X = Std.int (xf) & 255;
					Y = Std.int (yf) & 255;
					Z = Std.int (zf) & 255;
					
					x -= xf;
					y -= yf;
					z -= zf;
					
					u = x * x * x * (x * (x*6 - 15) + 10);
					v = y * y * y * (y * (y*6 - 15) + 10);
					w = z * z * z * (z * (z*6 - 15) + 10);
					
					A  =(p[X]) + Y;
					AA =(p[A]) + Z;
					AB =(p[A+1]) + Z;
					B  =(p[X+1]) + Y;
					BA =(p[B]) + Z;
					BB =(p[B+1]) + Z;
					
					x1 = x - 1;
					y1 = y - 1;
					z1 = z - 1;
					
					hash =(p[BB+1]) & 15;
					g1 = ((hash & 1) == 0 ?(hash < 8 ? x1 : y1) :(hash < 8 ? -x1 : -y1)) + ((hash & 2) == 0 ? hash < 4 ? y1 :( hash == 12 ? x1 : z1 ) : hash < 4 ? -y1 :( hash == 14 ? -x1 : -z1 ));
					
					hash =(p[AB+1]) & 15;
					g2 =((hash&1) == 0 ?(hash<8 ? x  : y1) :(hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 :( hash==12 ? x  : z1 ) : hash<4 ? -y1 :( hash==14 ? -x : -z1 ));
					
					hash =(p[BA+1]) & 15;
					g3 =((hash&1) == 0 ?(hash<8 ? x1 : y ) :(hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  :( hash==12 ? x1 : z1 ) : hash<4 ? -y  :( hash==14 ? -x1 : -z1 ));
					
					hash =(p[AA+1]) & 15;
					g4 =((hash&1) == 0 ?(hash<8 ? x  : y ) :(hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  :( hash==12 ? x  : z1 ) : hash<4 ? -y  :( hash==14 ? -x  : -z1 ));
					
					hash =(p[BB]) & 15;
					g5 =((hash&1) == 0 ?(hash<8 ? x1 : y1) :(hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 :( hash==12 ? x1 : z  ) : hash<4 ? -y1 :( hash==14 ? -x1 : -z  ));
					
					hash =(p[AB]) & 15;
					g6 =((hash&1) == 0 ?(hash<8 ? x  : y1) :(hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 :( hash==12 ? x  : z  ) : hash<4 ? -y1 :( hash==14 ? -x  : -z  ));
					
					hash =(p[BA]) & 15;
					g7 =((hash&1) == 0 ?(hash<8 ? x1 : y ) :(hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  :( hash==12 ? x1 : z  ) : hash<4 ? -y  :( hash==14 ? -x1 : -z  ));
					
					hash =(p[AA]) & 15;
					g8 =((hash&1) == 0 ?(hash<8 ? x  : y ) :(hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  :( hash==12 ? x  : z  ) : hash<4 ? -y  :( hash==14 ? -x  : -z  ));
					
					g2 += u * (g1 - g2);
					g4 += u * (g3 - g4);
					g6 += u * (g5 - g6);
					g8 += u * (g7 - g8);
					
					g4 += v * (g2 - g4);
					g8 += v * (g6 - g8);
					
					s += ( g8 + w * (g4 - g8)) * fPers;
					
				}
				
				color = Std.int (( s * fPersMax + 1 ) * 128);
				pixel = 0xff000000 | color << 16 | color << 8 | color;
				
				bitmap.setPixel32 (px, py, pixel);
				
				_x += baseFactor;
				
			}
			
			_y += baseFactor;
			
		}
		
	}
	
	
	private function octFreqPers (fPersistence:Float):Void {
		
		var fFreq:Float, fPers:Float;
		
		aOctFreq = [];
		aOctPers = [];
		fPersMax = 0;
		
		for (i in 0...octaves) {
			
			fFreq = Math.pow (2, i);
			fPers = Math.pow (fPersistence, i);
			fPersMax += fPers;
			aOctFreq.push (fFreq);
			aOctPers.push (fPers);
			
		}
		
		fPersMax = 1 / fPersMax;
		
	}
	
	
	private function seedOffset (iSeed:Int):Void {
		
		iXoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
		iYoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
		iZoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
		
	}
	
	
}


#end