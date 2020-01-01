package openfl._internal.backend.html5;

#if openfl_html5
class HTML5SystemBackend
{
	public static function exit(code:Int):Void {}

	public static function gc():Void {}

	public static function getTotalMemory():Int
	{
		return untyped __js__("(window.performance && window.performance.memory) ? window.performance.memory.usedJSHeapSize : 0");
	}
}
#end
