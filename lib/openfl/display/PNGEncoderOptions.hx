package openfl.display;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/display/PNGEncoderOptions", "default")
#end
@:final extern class PNGEncoderOptions
{
	public var fastCompression:Bool;
	public function new(fastCompression:Bool = false):Void;
}
#else
typedef PNGEncoderOptions = flash.display.PNGEncoderOptions;
#end
