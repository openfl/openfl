package system;

import openfl.errors.Error;
import openfl.utils.Timer;

class TimerAsyncTest
{
	#if test_timer
	@AsyncTest public function timerFinished()
	{
		// TODO: Lower MS values make this test fails completely
		var timer = new Timer(50, 2);
		timer.start();

		var handler:Dynamic = Async.handler(this, function():Void
		{
			Assert.isFalse(timer.running);
			Assert.areEqual(2, timer.currentCount);
		}, 800);
		// setting timout 2x desired delay and timer 1.5x desired delayed

		var m_timer = massive.munit.util.Timer.delay(handler, 150);
	}

	@AsyncTest public function timerRunning()
	{
		var timer = new Timer(100, 5);
		timer.start();

		var handler:Dynamic = Async.handler(this, function():Void
		{
			Assert.isTrue(timer.running);
			Assert.isTrue(timer.currentCount == 1 || timer.currentCount == 2 || timer.currentCount == 3); // TODO: timer resolution?
		}, 500);

		var m_timer = massive.munit.util.Timer.delay(handler, 250);
	}

	@AsyncTest public function repeatCountDuringTimer()
	{
		var timer = new Timer(100, 5);
		timer.start();

		Assert.areEqual(0, timer.currentCount);

		var handler:Dynamic = Async.handler(this, function():Void
		{
			timer.repeatCount = 1;

			Assert.isFalse(timer.running);
			Assert.areEqual(1, timer.repeatCount);

			#if flash
			Assert.isTrue(timer.currentCount == 2 || timer.currentCount == 3); // TODO: timer resolution?
			#else
			Assert.isTrue(timer.currentCount == 1 || timer.currentCount == 2 || timer.currentCount == 3); // TODO: timer resolution?
			#end
		}, 500);

		var m_timer = massive.munit.util.Timer.delay(handler, 250);
	}
	#end
}
