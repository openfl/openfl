package openfl._internal.backend.lime_standalone;

#if openfl_html5
import openfl.geom.Rectangle;

class Display
{
	public var bounds(default, null):Rectangle;
	public var currentMode(default, null):DisplayMode;
	public var id(default, null):Int;
	public var dpi(default, null):Float;
	public var name(default, null):String;
	public var supportedModes(default, null):Array<DisplayMode>;

	@:noCompletion private function new() {}
}
#end
