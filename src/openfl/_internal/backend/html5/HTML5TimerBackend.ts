namespace openfl._internal.backend.html5;

#if openfl_html5
import js.Browser;
import openfl.utils.Timer;

@: access(openfl.utils.Timer)
class HTML5TimerBackend
{
	private parent: Timer;
	private timerID: null | number;

	public new(parent: Timer)
	{
		this.parent = parent;
	}

	public start(): void
	{
		timerID = Browser.window.setInterval(parent.timer_onTimer, Std.int(parent.__delay));
	}

	public stop(): void
	{
		if (timerID != null)
		{
			Browser.window.clearInterval(timerID);
			timerID = null;
		}
	}
}
#end
