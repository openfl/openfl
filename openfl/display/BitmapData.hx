package openfl.display; #if !flash


import lime.graphics.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.graphics.GLTexture;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
import openfl._internal.data.CanvasBitmapData;
import openfl._internal.data.BitmapDataArray;
import openfl._internal.renderer.RenderSession;
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
#end

@:autoBuild(openfl.Assets.embedBitmap())


class BitmapData implements IBitmapDrawable {
	
	
	public var height (default, null):Int;
	public var rect (default, null):Rectangle;
	public var transparent (default, null):Bool;
	public var width (default, null):Int;
	
	public var __worldTransform:Matrix;
	
	private var __buffer:GLBuffer;
	private var __isValid:Bool;
	private var __loading:Bool;
	private var __sourceBytes:UInt8Array;
	private var __texture:GLTexture;
	private var __uvData:TextureUvs;
	
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
			CanvasBitmapData.create (this, fillColor);
			#end
			
		}
		
		__createUVs ();
		
	}
	
	
	public function applyFilter (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {
		
		#if js
		CanvasBitmapData.applyFilter (this, sourceBitmapData, sourceRect, destPoint, filter);
		#end
		
	}
	
	
	public function clone ():BitmapData {
		
		#if js
		return CanvasBitmapData.clone (this);
		#else
		return BitmapDataArray.clone (this);
		#end
		
	}
	
	
	public function colorTransform (rect:Rectangle, colorTransform:ColorTransform):Void {
		
		#if js
		CanvasBitmapData.colorTransform (this, rect, colorTransform);
		#end
		
	}
	
	
	public function copyChannel (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:Int, destChannel:Int):Void {
		
		#if js
		CanvasBitmapData.copyChannel (this, sourceBitmapData, sourceRect, destPoint, sourceChannel, destChannel);
		#end
		
	}
	
	
	public function copyPixels (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void {
		
		#if js
		CanvasBitmapData.copyPixels (this, sourceBitmapData, sourceRect, destPoint, alphaBitmapData, alphaPoint, mergeAlpha);
		#end
		
	}
	
	
	public function dispose ():Void {
		
		#if js
		CanvasBitmapData.dispose (this);
		#else
		BitmapDataArray.dispose (this);
		#end
		
		width = 0;
		height = 0;
		rect = null;
		__isValid = false;
		
	}
	
	
	public function draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		#if js
		CanvasBitmapData.draw (this, source, matrix, colorTransform, blendMode, clipRect, smoothing);
		#end
		
	}
	
	
	public function encode (rect:Rectangle, compressor:Dynamic, byteArray:ByteArray = null):ByteArray {
		
		openfl.Lib.notImplemented ("BitmapData.encode");
		return null;
		
	}
	
	
	public function fillRect (rect:Rectangle, color:Int):Void {
		
		#if js
		CanvasBitmapData.fillRect (this, rect, color);
		#end
		
	}
	
	
	public function floodFill (x:Int, y:Int, color:Int):Void {
		
		#if js
		CanvasBitmapData.floodFill (this, x, y, color);
		#end
		
	}
	
	
	public static function fromBase64 (base64:String, type:String, onload:BitmapData -> Void):BitmapData {
		
		#if js
		return CanvasBitmapData.fromBase64 (base64, type, onload);
		#else
		return null;
		#end
		
	}
	
	
	public static function fromBytes (bytes:ByteArray, rawAlpha:ByteArray = null, onload:BitmapData -> Void):BitmapData {
		
		#if js
		return CanvasBitmapData.fromBytes (bytes, rawAlpha, onload);
		#else
		return null;
		#end
		
	}
	
	
	public static function fromFile (path:String, onload:BitmapData -> Void = null, onfail:Void -> Void = null):BitmapData {
		
		#if js
		return CanvasBitmapData.fromFile (path, onload, onfail);
		#else
		return null;
		#end
		
	}
	
	
	public static function fromImage (image:lime.graphics.Image, transparent:Bool = true):BitmapData {
		
		#if js
		return CanvasBitmapData.fromImage (image, transparent);
		#else
		return BitmapDataArray.fromImage (image, transparent);
		#end
		
	}
	
	
	#if js
	public static function fromCanvas (canvas:CanvasElement, transparent:Bool = true):BitmapData {
		
		return CanvasBitmapData.fromCanvas (canvas, transparent);
		
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
		return CanvasBitmapData.getPixel (this, x, y);
		#else
		return 0;
		#end
		
	}
	
	
	public function getPixel32 (x:Int, y:Int):Int {
		
		#if js
		return CanvasBitmapData.getPixel32 (this, x, y);
		#else
		return 0;
		#end
		
	}
	
	
	public function getPixels (rect:Rectangle):ByteArray {
		
		#if js
		return CanvasBitmapData.getPixels (this, rect);
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
			if (__sourceBytes == null) {
				
				CanvasBitmapData.convertToCanvas (this);
				
				var pixels = __sourceContext.getImageData (0, 0, width, height);
				var data = new lime.graphics.ImageData (pixels.data);
				data.premultiply ();
				
				__sourceBytes = data;
				
			}
			#end
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, __sourceBytes);
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
		
		#if js
		CanvasBitmapData.paletteMap (this, sourceBitmapData, sourceRect, destPoint, redArray, greenArray, blueArray, alphaArray);
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
		CanvasBitmapData.setPixel (this, x, y, color);
		#end
		
	}
	
	
	public function setPixel32 (x:Int, y:Int, color:Int):Void {
		
		#if js
		CanvasBitmapData.setPixel32 (this, x, y, color);
		#end
		
	}
	
	
	public function setPixels (rect:Rectangle, byteArray:ByteArray):Void {
		
		#if js
		CanvasBitmapData.setPixels (this, rect, byteArray);
		#end
		
	}
	
	
	public function setVector (rect:Rectangle, inputVector:Vector<UInt>) {
		
		#if js
		CanvasBitmapData.setVector (this, rect, inputVector);
		#end
		
	}
	
	
	public function threshold (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000, mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int {
		
		#if js
		return CanvasBitmapData.threshold (this, sourceBitmapData, sourceRect, destPoint, operation, threshold, color, mask, copySource);
		#else
		return 0;
		#end
		
	}
	
	
	public function unlock (changeRect:Rectangle = null):Void {
		
		
		
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
	
	
	public function __renderCanvas (renderSession:RenderSession):Void {
		
		#if js
		CanvasBitmapData.__renderCanvas (this, renderSession);
		#end
		
	}
	
	
	public function __renderMask (renderSession:RenderSession):Void {
		
		
		
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