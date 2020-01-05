package openfl._internal.backend.dummy;

import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.IBitmapDrawable;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Future;
import openfl.utils.Object;
import openfl.Vector;
#if openfl_gl
import openfl._internal.renderer.context3D.batcher.BatchRenderer;
#end

class DummyBitmapDataBackend
{
	public function new(parent:BitmapData, width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF) {}

	public function applyFilter(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {}

	public function clone():BitmapData
	{
		return null;
	}

	public function colorTransform(rect:Rectangle, colorTransform:ColorTransform):Void {}

	public function compare(otherBitmapData:BitmapData):Dynamic
	{
		return 0;
	}

	public function copyChannel(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:BitmapDataChannel,
		destChannel:BitmapDataChannel):Void {}

	public function copyPixels(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null,
		mergeAlpha:Bool = false):Void {}

	public function dispose():Void {}

	@:beta public function disposeImage():Void {}

	public function draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null,
		clipRect:Rectangle = null, smoothing:Bool = false):Void {}

	public function drawWithQuality(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null,
		clipRect:Rectangle = null, smoothing:Bool = false, quality:StageQuality = null):Void {}

	public function encode(rect:Rectangle, compressor:Object, byteArray:ByteArray = null):ByteArray
	{
		return null;
	}

	public function fillRect(rect:Rectangle, color:Int):Void {}

	public function floodFill(x:Int, y:Int, color:Int):Void {}

	public static function fromBase64(base64:String, type:String):BitmapData
	{
		return null;
	}

	public static function fromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):BitmapData
	{
		return null;
	}

	public static function fromFile(path:String):BitmapData
	{
		return null;
	}

	public static function fromTexture(texture:TextureBase):BitmapData
	{
		return null;
	}

	public function generateFilterRect(sourceRect:Rectangle, filter:BitmapFilter):Rectangle
	{
		return null;
	}

	@:dox(hide) public function getIndexBuffer(context:Context3D, scale9Grid:Rectangle = null):IndexBuffer3D
	{
		return null;
	}

	#if (openfl_gl && !disable_batcher)
	@:dox(hide) public function pushQuadsToBatcher(batcher:BatchRenderer, transform:Matrix, alpha:Float, object:DisplayObject):Void {}
	#end

	@:dox(hide) public function getVertexBuffer(context:Context3D, scale9Grid:Rectangle = null, targetObject:DisplayObject = null):VertexBuffer3D
	{
		return null;
	}

	public function getColorBoundsRect(mask:Int, color:Int, findColor:Bool = true):Rectangle
	{
		return null;
	}

	public function getPixel(x:Int, y:Int):Int
	{
		return 0;
	}

	public function getPixel32(x:Int, y:Int):Int
	{
		return 0;
	}

	public function getPixels(rect:Rectangle):ByteArray
	{
		return null;
	}

	@:dox(hide) public function getSurface():#if lime CairoImageSurface #else Dynamic #end
	{
		return null;
	}

	@:dox(hide) public function getTexture(context:Context3D):TextureBase
	{
		return null;
	}

	public function getVector(rect:Rectangle):Vector<UInt>
	{
		return null;
	}

	public function histogram(hRect:Rectangle = null):Array<Array<Int>>
	{
		return null;
	}

	public function hitTest(firstPoint:Point, firstAlphaThreshold:Int, secondObject:Object, secondBitmapDataPoint:Point = null,
			secondAlphaThreshold:Int = 1):Bool
	{
		return false;
	}

	public static function loadFromBase64(base64:String, type:String):Future<BitmapData>
	{
		return null;
	}

	public static function loadFromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData>
	{
		return null;
	}

	public static function loadFromFile(path:String):Future<BitmapData>
	{
		return null;
	}

	public function lock():Void {}

	public function merge(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt,
		alphaMultiplier:UInt):Void {}

	public function noise(randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false):Void {}

	public function paletteMap(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redArray:Array<Int> = null, greenArray:Array<Int> = null,
		blueArray:Array<Int> = null, alphaArray:Array<Int> = null):Void {}

	public function perlinNoise(baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7,
		grayScale:Bool = false, offsets:Array<Point> = null):Void {}

	public function scroll(x:Int, y:Int):Void {}

	public function setPixel(x:Int, y:Int, color:Int):Void {}

	public function setPixel32(x:Int, y:Int, color:Int):Void {}

	public function setPixels(rect:Rectangle, byteArray:ByteArray):Void {}

	public function setVector(rect:Rectangle, inputVector:Vector<UInt>):Void {}

	public function threshold(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000,
			mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int
	{
		return 0;
	}

	public function unlock(changeRect:Rectangle = null):Void {}

	private function __applyAlpha(alpha:ByteArray):Void {}

	private inline function __fromBase64(base64:String, type:String):Void {}

	private inline function __fromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Void {}

	private function __fromFile(path:String):Void {}

	private inline function __loadFromBase64(base64:String, type:String):Future<BitmapData>
	{
		return null;
	}

	private inline function __loadFromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData>
	{
		return null;
	}

	private function __loadFromFile(path:String):Future<BitmapData>
	{
		return null;
	}

	private function __resize(width:Int, height:Int):Void {}

	private function __setUVRect(context:Context3D, x:Float, y:Float, width:Float, height:Float):Void {}

	private function __setVertex(index:Int, x:Float, y:Float, u:Float, v:Float):Void {}

	private function __setVertices(indices:Array<Int>, x:Float, y:Float, u:Float, v:Float):Void {}

	private function __setUOffsets(indices:Array<Int>, offset:Float):Void {}

	private function __setVOffsets(indices:Array<Int>, offset:Float):Void {}

	private function __sync():Void {}

	private inline function __powerOfTwo(value:Int):Int
	{
		return value;
	}
}
