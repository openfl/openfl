package openfl.display;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class PNGEncoderOptions
{
	public var fastCompression:Bool;

	public function new(fastCompression:Bool = false)
	{
		this.fastCompression = fastCompression;
	}
}
#else
typedef PNGEncoderOptions = flash.display.PNGEncoderOptions;
#end
