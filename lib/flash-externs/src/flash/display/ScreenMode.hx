package flash.display;

#if (flash && air)
extern class ScreenMode
{
	#if (haxe_ver < 4.3)
	var colorDepth(default, never):Int;
	var height(default, never):Int;
	var refreshRate(default, never):Int;
	var width(default, never):Int;
	#else
	@:flash.property var colorDepth(get, never):Int;
	@:flash.property var height(get, never):Int;
	@:flash.property var refreshRate(get, never):Int;
	@:flash.property var width(get, never):Int;
	#end
	function new():Void;

	#if (haxe_ver >= 4.3)
	private function get_colorDepth():Int;
	private function get_height():Int;
	private function get_refreshRate():Int;
	private function get_width():Int;
	#end
}
#end
