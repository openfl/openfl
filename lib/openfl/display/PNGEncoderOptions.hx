package openfl.display;

#if (display || !flash)
/**
	The PNGEncoderOptions class defines a compression algorithm for the
	`openfl.display.BitmapData.encode()` method.
**/
@:jsRequire("openfl/display/PNGEncoderOptions", "default")
@:final extern class PNGEncoderOptions
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
	public function new(fastCompression:Bool = false):Void;
}
#else
typedef PNGEncoderOptions = flash.display.PNGEncoderOptions;
#end
