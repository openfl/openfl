namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
class DisplayMode
{
	public height(default , null): number;
	public pixelFormat(default , null): PixelFormat;
	public refreshRate(default , null): number;
	public width(default , null): number;

	protected new(width: number, height: number, refreshRate: number, pixelFormat: PixelFormat)
	{
		this.width = width;
		this.height = height;
		this.refreshRate = refreshRate;
		this.pixelFormat = pixelFormat;
	}
}
#end
