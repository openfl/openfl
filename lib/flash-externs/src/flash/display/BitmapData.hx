package flash.display;

#if flash
import lime.app.Future;
import lime.app.Promise;
import lime.graphics.Image;
import openfl.display.BitmapDataChannel;
import openfl.display3D.textures.TextureBase;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Object;

extern class BitmapData implements IBitmapDrawable
{
	public var height(default, never):Int;
	public var image(get, never):Image;
	@:noCompletion private inline function get_image():Image
	{
		return null;
	}
	public var readable(get, never):Bool;
	@:noCompletion private inline function get_readable():Bool
	{
		return true;
	}
	public var rect(default, never):Rectangle;
	public var transparent(default, never):Bool;
	public var width(default, never):Int;
	public function new(width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF);
	public function applyFilter(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void;
	public function clone():BitmapData;
	public function colorTransform(rect:Rectangle, colorTransform:ColorTransform):Void;
	public function compare(otherBitmapData:BitmapData):Object;
	public function copyChannel(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:BitmapDataChannel,
		destChannel:BitmapDataChannel):Void;
	public function copyPixels(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null,
		mergeAlpha:Bool = false):Void;
	#if flash
	@:require(flash11_4) public function copyPixelsToByteArray(rect:Rectangle, data:ByteArray):Void;
	#end
	public function dispose():Void;
	public inline function disposeImage():Void {}
	public function draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null,
		clipRect:Rectangle = null, smoothing:Bool = false):Void;
	@:require(flash11_3) public function drawWithQuality(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null,
		blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false, quality:StageQuality = null):Void;
	@:require(flash11_3) public function encode(rect:Rectangle, compressor:Object, byteArray:ByteArray = null):ByteArray;
	public function fillRect(rect:Rectangle, color:UInt):Void;
	public function floodFill(x:Int, y:Int, color:UInt):Void;
	public static inline function fromBase64(base64:String, type:String):BitmapData
	{
		return null;
	}
	public static inline function fromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):BitmapData
	{
		return null;
	}
	public static inline function fromFile(path:String):BitmapData
	{
		return null;
	}
	public static inline function fromImage(image:Image, transparent:Bool = true):BitmapData
	{
		#if flash
		return image.src;
		#else
		return null;
		#end
	}
	public static inline function fromTexture(texture:TextureBase):BitmapData
	{
		return null;
	}
	public function generateFilterRect(sourceRect:Rectangle, filter:BitmapFilter):Rectangle;
	public function getColorBoundsRect(mask:UInt, color:UInt, findColor:Bool = true):Rectangle;
	public function getPixel(x:Int, y:Int):Int;
	public function getPixel32(x:Int, y:Int):Int;
	public function getPixels(rect:Rectangle):ByteArray;
	@:require(flash10) public function getVector(rect:Rectangle):Vector<UInt>;
	@:require(flash10) public function histogram(hRect:Rectangle = null):Vector<Vector<Float>>;
	public function hitTest(firstPoint:Point, firstAlphaThreshold:UInt, secondObject:Object, secondBitmapDataPoint:Point = null,
		secondAlphaThreshold:UInt = 1):Bool;
	public static inline function loadFromBase64(base64:String, type:String):Future<BitmapData>
	{
		return Image.loadFromBase64(base64, type).then(function(image)
		{
			if (image == null)
			{
				return Future.withValue(null);
			}
			else
			{
				return Future.withValue(image.src);
			}
		});
	}
	public static inline function loadFromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData>
	{
		return Image.loadFromBytes(bytes).then(function(image)
		{
			if (image == null)
			{
				return Future.withValue(null);
			}
			else
			{
				var bitmapData:BitmapData = image.src;

				if (rawAlpha != null)
				{
					var data = bitmapData.getPixels(bitmapData.rect);

					for (i in 0...rawAlpha.length)
					{
						data[i * 4] = rawAlpha.readUnsignedByte();
					}

					bitmapData.setPixels(bitmapData.rect, data);
				}

				return Future.withValue(bitmapData);
			}
		});
	}
	public static inline function loadFromFile(path:String):Future<BitmapData>
	{
		return Image.loadFromFile(path).then(function(image)
		{
			if (image == null)
			{
				return Future.withValue(null);
			}
			else
			{
				return Future.withValue(image.src);
			}
		});
	}
	public function lock():Void;
	public function merge(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt,
		alphaMultiplier:UInt):Void;
	public function noise(randomSeed:Int, low:UInt = 0, high:UInt = 255, channelOptions:UInt = 7, grayScale:Bool = false):Void;
	public function paletteMap(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redArray:Array<Int> = null, greenArray:Array<Int> = null,
		blueArray:Array<Int> = null, alphaArray:Array<Int> = null):Void;
	public function perlinNoise(baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7,
		grayScale:Bool = false, offsets:Array<Point> = null):Void;
	#if flash
	public function pixelDissolve(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, randomSeed:Int = 0, numPixels:Int = 0,
		fillColor:UInt = 0):Int;
	#end
	public function scroll(x:Int, y:Int):Void;
	public function setPixel(x:Int, y:Int, color:UInt):Void;
	public function setPixel32(x:Int, y:Int, color:UInt):Void;
	public function setPixels(rect:Rectangle, byteArray:ByteArray):Void;
	@:require(flash10) public function setVector(rect:Rectangle, inputVector:Vector<UInt>):Void;
	public function threshold(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:UInt, color:UInt = 0x00000000,
		mask:UInt = 0xFFFFFFFF, copySource:Bool = false):Int;
	public function unlock(changeRect:Rectangle = null):Void;
}
#else
typedef BitmapData = openfl.display.BitmapData;
#end
