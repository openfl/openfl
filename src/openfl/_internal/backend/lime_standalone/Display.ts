namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
import Rectangle from "openfl/geom/Rectangle";

class Display
{
	public bounds(default , null): Rectangle;
	public currentMode(default , null): DisplayMode;
	public id(default , null): number;
	public dpi(default , null): number;
	public name(default , null): string;
	public supportedModes(default , null): Array<DisplayMode>;

	protected new() { }
}
#end
