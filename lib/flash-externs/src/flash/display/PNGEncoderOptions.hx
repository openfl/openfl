package flash.display;

#if flash
@:final extern class PNGEncoderOptions
{
	public var fastCompression:Bool;
	public function new(fastCompression:Bool = false):Void;
}
#else
typedef PNGEncoderOptions = openfl.display.PNGEncoderOptions;
#end
