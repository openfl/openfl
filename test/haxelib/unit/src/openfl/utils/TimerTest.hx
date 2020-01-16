package openfl.utils;

import openfl.errors.Error;
import massive.munit.Assert;

class TimerTest
{
	@Test public function new_()
	{
		var timer_default = new Timer(123);

		Assert.areEqual(false, timer_default.running);
		Assert.areEqual(123, timer_default.delay);
		Assert.areEqual(0, timer_default.repeatCount);
		Assert.areEqual(0, timer_default.currentCount);

		var timer = new Timer(234, 5);

		Assert.areEqual(false, timer.running);
		Assert.areEqual(234, timer.delay);
		Assert.areEqual(5, timer.repeatCount);
		Assert.areEqual(0, timer.currentCount);
	}

	@Test public function newError()
	{
		Assert.throws(Error, function():Void
		{
			new Timer(-100.0);
		});
	}

	@Test public function delay()
	{
		var timer = new Timer(123);
		timer.start();

		Assert.areEqual(123, timer.delay);
		Assert.areEqual(true, timer.running);

		timer.delay = 321;

		Assert.areEqual(321, timer.delay);
		Assert.areEqual(true, timer.running);
	}

	@Test public function repeatCount()
	{
		var timer_default = new Timer(123);

		Assert.areEqual(0, timer_default.repeatCount);

		var timer = new Timer(123, 3);

		Assert.areEqual(3, timer.repeatCount);

		timer.repeatCount = 10;

		Assert.areEqual(10, timer.repeatCount);

		// TODO: Actual timer ticks tests
	}

	@Test public function running()
	{
		var timer = new Timer(123);

		Assert.areEqual(false, timer.running);

		timer.start();

		Assert.areEqual(true, timer.running);
	}

	@Test public function reset()
	{
		var timer = new Timer(123);
		timer.start();

		Assert.areEqual(true, timer.running);

		timer.reset();

		Assert.areEqual(0, timer.currentCount);
		Assert.areEqual(false, timer.running);
	}

	@Test public function start()
	{
		var timer = new Timer(123);

		Assert.areEqual(false, timer.running);

		timer.start();

		Assert.areEqual(true, timer.running);
	}

	@Test public function stop()
	{
		var timer = new Timer(123);
		timer.start();

		Assert.areEqual(true, timer.running);

		timer.stop();

		Assert.areEqual(false, timer.running);
	}
}
