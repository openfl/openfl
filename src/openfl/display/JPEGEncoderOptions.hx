package openfl.display;

#if !flash
#if lime
import openfl.utils.ByteArray;
import lime.graphics.Image;
#end
/**
	The JPEGEncoderOptions class defines a compression algorithm for the
	`openfl.display.BitmapData.encode()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class JPEGEncoderOptions implements IEncoderOptions
{
	/**
		A value between 1 and 100, where 1 means the lowest quality and 100 means the
		highest quality. The higher the value, the larger the size of the output of the
		compression, and the smaller the compression ratio.
	**/
	public var quality:Int;

	/**
		Creates a JPEGEncoderOptions object with the specified setting.

		@param	quality	The initial quality value.
	**/
	public function new(quality:Int = 80)
	{
		this.quality = quality;
	}

	#if lime
	@:noCompletion @:keep private function encode(image:#if lime Image #else Dynamic #end, byteArray:ByteArray):ByteArray
	{
		byteArray.writeBytes(ByteArray.fromBytes(image.encode(JPEG, quality)));
		return byteArray;
	}
	#end
}
#else
typedef JPEGEncoderOptions = flash.display.JPEGEncoderOptions;
#end