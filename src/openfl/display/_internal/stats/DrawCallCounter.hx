package openfl.display._internal.stats;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class DrawCallCounter
{
	public var currentDrawCallsNum(default, null):Int = 0;

	private var drawCallsCounter:Int = 0;

	public function new()
	{
		currentDrawCallsNum = 0;
		drawCallsCounter = 0;
	}

	public function increment():Void
	{
		drawCallsCounter++;
	}

	public function reset():Void
	{
		currentDrawCallsNum = drawCallsCounter;
		drawCallsCounter = 0;
	}
}
