package;

import openfl.errors.Error;
import openfl.utils.Timer;
import utest.Assert;
import utest.Test;

class TimerTest extends Test
{
	public function test_new_()
	{
		var timer_default = new Timer(123);

		Assert.equals(false, timer_default.running);
		Assert.equals(123, timer_default.delay);
		Assert.equals(0, timer_default.repeatCount);
		Assert.equals(0, timer_default.currentCount);

		var timer = new Timer(234, 5);

		Assert.equals(false, timer.running);
		Assert.equals(234, timer.delay);
		Assert.equals(5, timer.repeatCount);
		Assert.equals(0, timer.currentCount);
	}

	public function test_newError()
	{
		Assert.raises(function():Void
		{
			new Timer(-100.0);
		}, Error);
	}

	public function test_delay()
	{
		var timer = new Timer(123);
		timer.start();

		Assert.equals(123, timer.delay);
		Assert.equals(true, timer.running);

		timer.delay = 321;

		Assert.equals(321, timer.delay);
		Assert.equals(true, timer.running);
	}

	public function test_repeatCount()
	{
		var timer_default = new Timer(123);

		Assert.equals(0, timer_default.repeatCount);

		var timer = new Timer(123, 3);

		Assert.equals(3, timer.repeatCount);

		timer.repeatCount = 10;

		Assert.equals(10, timer.repeatCount);

		// TODO: Actual timer ticks tests
	}

	public function test_running()
	{
		var timer = new Timer(123);

		Assert.equals(false, timer.running);

		timer.start();

		Assert.equals(true, timer.running);
	}

	public function test_reset()
	{
		var timer = new Timer(123);
		timer.start();

		Assert.equals(true, timer.running);

		timer.reset();

		Assert.equals(0, timer.currentCount);
		Assert.equals(false, timer.running);
	}

	public function test_start()
	{
		var timer = new Timer(123);

		Assert.equals(false, timer.running);

		timer.start();

		Assert.equals(true, timer.running);
	}

	public function test_stop()
	{
		var timer = new Timer(123);
		timer.start();

		Assert.equals(true, timer.running);

		timer.stop();

		Assert.equals(false, timer.running);
	}
}
