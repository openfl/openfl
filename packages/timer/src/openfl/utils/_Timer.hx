package openfl.utils;

#if sys
import haxe.Timer as HaxeTimer;
import openfl.utils.Timer;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.utils.Timer)
@:noCompletion
class _Timer
{
	private var parent:Timer;
	private var timer:HaxeTimer;

	public function new(parent:Timer)
	{
		this.parent = parent;
	}

	public function start():Void
	{
		timer = new HaxeTimer(Std.int(parent.__delay));
		timer.run = parent.timer_onTimer;
	}

	public function stop():Void
	{
		if (timer != null)
		{
			timer.stop();
			timer = null;
		}
	}
}
#end
