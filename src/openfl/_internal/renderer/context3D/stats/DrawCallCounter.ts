namespace openfl._internal.renderer.context3D.stats;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class DrawCallCounter
{
	public currentDrawCallsNum(default , null): number = 0;

	private drawCallsCounter: number = 0;

	public constructor()
	{
		currentDrawCallsNum = 0;
		drawCallsCounter = 0;
	}

	public increment(): void
	{
		drawCallsCounter++;
	}

	public reset(): void
	{
		currentDrawCallsNum = drawCallsCounter;
		drawCallsCounter = 0;
	}
}
