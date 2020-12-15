package;

import haxe.Timer as HaxeTimer;
import openfl.errors.Error;
import openfl.utils.Timer;
import utest.Assert;
import utest.Async;
import utest.Test;

class TimerAsyncTest extends Test
{
	// #if test_timer
	public function test_timerFinished(async:Async)
	{
		// TODO: Lower MS values make this test fails completely
		var timer = new Timer(50, 2);
		timer.start();

		HaxeTimer.delay(function()
		{
			Assert.isFalse(timer.running);
			Assert.equals(2, timer.currentCount);
			async.done();
		}, 150);
	}

	public function test_timerRunning(async:Async)
	{
		var timer = new Timer(100, 5);
		timer.start();

		HaxeTimer.delay(function()
		{
			Assert.isTrue(timer.running);
			Assert.isTrue(timer.currentCount == 1 || timer.currentCount == 2 || timer.currentCount == 3); // TODO: timer resolution?
			async.done();
		}, 250);
	}

	public function test_repeatCountDuringTimer(async:Async)
	{
		var timer = new Timer(100, 5);
		timer.start();

		Assert.equals(0, timer.currentCount);

		HaxeTimer.delay(function():Void
		{
			timer.repeatCount = 1;

			Assert.isFalse(timer.running);
			Assert.equals(1, timer.repeatCount);

			#if flash
			Assert.isTrue(timer.currentCount == 2 || timer.currentCount == 3); // TODO: timer resolution?
			#else
			Assert.isTrue(timer.currentCount == 1 || timer.currentCount == 2 || timer.currentCount == 3); // TODO: timer resolution?
			#end
			async.done();
		}, 250);
	}

	// #end
}
