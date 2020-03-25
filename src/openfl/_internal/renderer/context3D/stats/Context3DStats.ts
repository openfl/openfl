namespace openfl._internal.renderer.context3D.stats;

import haxe.ds.IntMap;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DStats
{
	private static drawCallsCounters: numberMap<DrawCallCounter> = [
		DrawCallContext.STAGE => new DrawCallCounter(),
		DrawCallContext.STAGE3D => new DrawCallCounter(),
		DrawCallContext.BATCHER => new DrawCallCounter()
	];

	public static incrementDrawCall(context: DrawCallContext): void
	{
		drawCallsCounters.get(context).increment();
	}

	public static resetDrawCalls(): void
	{
		for (dcCounter in drawCallsCounters)
		{
			dcCounter.reset();
		}
	}

	public static totalDrawCalls(): number
	{
		var total = 0;
		for (dcCounter in drawCallsCounters)
		{
			total += dcCounter.currentDrawCallsNum;
		}

		return total;
	}

	public static contextDrawCalls(context: DrawCallContext): number
	{
		return drawCallsCounters.get(context).currentDrawCallsNum;
	}
}
