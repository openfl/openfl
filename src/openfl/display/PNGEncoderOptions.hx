package openfl.display;

#if !flash
#if lime
import openfl.utils.ByteArray;
import lime.graphics.Image;
#end
/**
	The PNGEncoderOptions class defines a compression algorithm for the
	`openfl.display.BitmapData.encode()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class PNGEncoderOptions implements IEncoderOptions
{
	/**
		Chooses compression speed over file size. Setting this property to true improves
		compression speed but creates larger files.
	**/
	public var fastCompression:Bool;

	/**
		Creates a PNGEncoderOptions object, optionally specifying compression settings.

		@param	fastCompression	The initial compression mode.
	**/
	public function new(fastCompression:Bool = false)
	{
		this.fastCompression = fastCompression;
	}

	#if lime
	@:noCompletion @:keep private function encode(image:#if lime Image #else Dynamic #end, byteArray:ByteArray):ByteArray
	{
		byteArray.writeBytes(ByteArray.fromBytes(image.encode(PNG)));
		return byteArray;
	}
	#end
}
#else
typedef PNGEncoderOptions = flash.display.PNGEncoderOptions;
#end