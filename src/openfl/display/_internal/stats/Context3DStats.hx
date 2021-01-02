package openfl.display._internal.stats;

import haxe.ds.IntMap;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DStats
{
	private static var drawCallsCounters:IntMap<DrawCallCounter> = [
		DrawCallContext.STAGE => new DrawCallCounter(),
		DrawCallContext.STAGE3D => new DrawCallCounter()
	];

	public static function incrementDrawCall(context:DrawCallContext):Void
	{
		drawCallsCounters.get(context).increment();
	}

	public static function resetDrawCalls():Void
	{
		for (dcCounter in drawCallsCounters)
		{
			dcCounter.reset();
		}
	}

	public static function totalDrawCalls():Int
	{
		var total = 0;
		for (dcCounter in drawCallsCounters)
		{
			total += dcCounter.currentDrawCallsNum;
		}

		return total;
	}

	public static function contextDrawCalls(context:DrawCallContext):Int
	{
		return drawCallsCounters.get(context).currentDrawCallsNum;
	}
}
