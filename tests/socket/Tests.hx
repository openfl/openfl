import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ServerSocketTest());
		runner.addCase(new DatagramSocketTest());
		Report.create(runner);
		#if sys
		var done = false;
		runner.onComplete.add(function(_) done = true);
		#end
		runner.run();
		#if sys
		// `lime test` runs this inside an Application, which advances frames and timers itself
		if (lime.app.Application.current == null)
		{
			while (!done)
			{
				pump();
				Sys.sleep(0.005);
			}
		}
		#end
	}

	#if sys
	/**
		Run by hxp alone, there is no Application: nothing advances the
		sockets, which poll on ENTER_FRAME, nor the timers that time utest's
		async tests out, and the run returned from main() before the first
		async test ended, with no report.
	**/
	static function pump():Void
	{
		openfl.Lib.current.dispatchEvent(new openfl.events.Event(openfl.events.Event.ENTER_FRAME));
		#if lime_cffi
		// Lime's haxe.Timer, which NativeApplication.updateTimer() advances in an app;
		// before Lime 8.2, stop() leaves null in sRunningTimers
		@:privateAccess
		{
			var now = haxe.Timer.getMS();
			for (timer in haxe.Timer.sRunningTimers.copy())
			{
				if (timer != null && timer.mRunning && now >= timer.mFireAt)
				{
					timer.mFireAt += timer.mTime;
					timer.run();
				}
			}
			haxe.Timer.sRunningTimers = haxe.Timer.sRunningTimers.filter(function(timer) return timer != null && timer.mRunning);
		}
		#else
		@:privateAccess haxe.MainLoop.tick();
		#end
	}
	#end
}
