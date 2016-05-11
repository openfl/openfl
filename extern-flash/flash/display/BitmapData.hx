package flash.display; #if (!display && flash)


import lime.graphics.Image;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Object;


extern class BitmapData implements IBitmapDrawable {
	
	
	public var height (default, null):Int;
	
	public var image (get, never):Image;
	@:noCompletion private inline function get_image ():Image { return null; }
	
	public var rect (default, null):Rectangle;
	public var transparent (default, null):Bool;
	public var width (default, null):Int;
	
	public function new (width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF);
	public function applyFilter (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void;
	public function clone ():BitmapData;
	public function colorTransform (rect:Rectangle, colorTransform:ColorTransform):Void;
	public function compare (otherBitmapData:BitmapData):Object;
	public function copyChannel (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:UInt, destChannel:UInt):Void;
	public function copyPixels (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public function copyPixelsToByteArray (rect:Rectangle, data:ByteArray):Void;
	#end
	
	public function dispose ():Void;
	public function draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, ?blendMode:BlendMode, clipRect:Rectangle = null, smoothing:Bool = false):Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public function drawWithQuality (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, ?blendMode:BlendMode, clipRect:Rectangle = null, smoothing:Bool = false, ?quality:StageQuality) : Void;
	#end
	
	@:require(flash11_3) public function encode (rect:Rectangle, compressor:Object, byteArray:ByteArray = null):ByteArray;
	public function fillRect (rect:Rectangle, color:UInt):Void;
	public function floodFill (x:Int, y:Int, color:UInt):Void;
	
	
	public static inline function fromBase64 (base64:String, type:String, onload:BitmapData -> Void = null):BitmapData {
		
		return null;
		
	}
	
	
	public static inline function fromBytes (bytes:ByteArray, rawAlpha:ByteArray = null, onload:BitmapData -> Void = null):BitmapData {
		
		return null;
		
	}
	
	
	public static inline function fromFile (path:String, onload:BitmapData -> Void = null, onerror:Void -> Void = null):BitmapData {
		
		return null;
		
	}
	
	
	public static inline function fromImage (image:Image, transparent:Bool = true):BitmapData {
		
		#if flash
		return image.src;
		#else
		return null;
		#end
		
	}
	
	public function generateFilterRect (sourceRect:Rectangle, filter:BitmapFilter):Rectangle;
	public function getColorBoundsRect (mask:UInt, color:UInt, findColor:Bool = true):Rectangle;
	public function getPixel (x:Int, y:Int):Int;
	public function getPixel32 (x:Int, y:Int):Int;
	public function getPixels (rect:Rectangle):ByteArray;
	@:require(flash10) public function getVector (rect:Rectangle):Vector<UInt>;
	
	@:require(flash10) public function histogram (hRect:Rectangle = null):Vector<Vector<Float>>;
	public function hitTest (firstPoint:Point, firstAlphaThreshold:UInt, secondObject:Object, secondBitmapDataPoint:Point = null, secondAlphaThreshold:UInt = 1):Bool;
	public function lock ():Void;
	public function merge (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt, alphaMultiplier:UInt):Void;
	public function noise (randomSeed:Int, low:UInt = 0, high:UInt = 255, channelOptions:UInt = 7, grayScale:Bool = false):Void;
	public function paletteMap (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redArray:Array<Int> = null, greenArray:Array<Int> = null, blueArray:Array<Int> = null, alphaArray:Array<Int> = null):Void;
	public function perlinNoise (baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7, grayScale:Bool = false, offsets:Array<Point> = null):Void;
	
	#if flash
	@:noCompletion @:dox(hide) public function pixelDissolve (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, randomSeed:Int = 0, numPixels:Int = 0, fillColor:UInt = 0):Int;
	#end
	
	public function scroll (x:Int, y:Int):Void;
	public function setPixel (x:Int, y:Int, color:UInt):Void;
	public function setPixel32 (x:Int, y:Int, color:UInt):Void;
	public function setPixels (rect:Rectangle, byteArray:ByteArray):Void;
	@:require(flash10) public function setVector (rect:Rectangle, inputVector:Vector<UInt>):Void;
	public function threshold (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:UInt, color:UInt = 0x00000000, mask:UInt = 0xFFFFFFFF, copySource:Bool = false):Int;
	public function unlock (changeRect:Rectangle = null):Void;
	
	
}


#else
typedef BitmapData = openfl.display.BitmapData;
#end