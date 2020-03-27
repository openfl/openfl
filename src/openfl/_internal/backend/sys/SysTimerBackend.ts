namespace openfl._internal.backend.sys;

#if sys
import haxe.Timer as HaxeTimer;
import openfl.utils.Timer;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl.utils.Timer)
class SysTimerBackend
{
	private parent: Timer;
	private timer: HaxeTimer;

	public constructor(parent: Timer)
	{
		this.parent = parent;
	}

	public start(): void
	{
		timer = new HaxeTimer(Std.int(parent.__delay));
		timer.run = parent.timer_onTimer;
	}

	public stop(): void
	{
		if (timer != null)
		{
			timer.stop();
			timer = null;
		}
	}
}
#end
