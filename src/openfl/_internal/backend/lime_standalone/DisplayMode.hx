package openfl._internal.backend.lime_standalone;

#if openfl_html5
class DisplayMode
{
	public var height(default, null):Int;
	public var pixelFormat(default, null):PixelFormat;
	public var refreshRate(default, null):Int;
	public var width(default, null):Int;

	@:noCompletion private function new(width:Int, height:Int, refreshRate:Int, pixelFormat:PixelFormat)
	{
		this.width = width;
		this.height = height;
		this.refreshRate = refreshRate;
		this.pixelFormat = pixelFormat;
	}
}
#end
