package openfl._internal.backend.html5;

#if openfl_html5
import js.Browser;
import openfl.utils.Timer;

@:access(openfl.utils.Timer)
class HTML5TimerBackend
{
	private var parent:Timer;
	private var timerID:Null<Int>;

	public function new(parent:Timer)
	{
		this.parent = parent;
	}

	public function start():Void
	{
		timerID = Browser.window.setInterval(parent.timer_onTimer, Std.int(parent.__delay));
	}

	public function stop():Void
	{
		if (timerID != null)
		{
			Browser.window.clearInterval(timerID);
			timerID = null;
		}
	}
}
#end
