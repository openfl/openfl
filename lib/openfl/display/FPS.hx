package openfl.display;

import openfl.text.TextField;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
@:jsRequire("openfl/display/FPS", "default")
extern class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000);
}
