package openfl.utils;

import openfl.errors.Error;

import massive.munit.Assert;
import massive.munit.Async;

class TimerTest {
	@Test public function new_() {
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

	@Test public function newError() {
		Assert.throws(Error, function():Void {
			new Timer(-100.0);
		});
	}

	#if integration
	@AsyncTest public function timerFinished() {
		// TODO: Lower MS values make this test fails completely
		var timer = new Timer (50, 2);
		timer.start();

		var handler:Dynamic = Async.handler(this, function():Void {
			Assert.isFalse(timer.running);
			Assert.areEqual(2, timer.currentCount);
		}, 800);
		// setting timout 2x desired delay and timer 1.5x desired delayed

		var m_timer = massive.munit.util.Timer.delay(handler, 150);
	}
	#end

	#if integration
	@AsyncTest public function timerRunning() {
		var timer = new Timer (100, 5);
		timer.start();

		var handler:Dynamic = Async.handler(this, function():Void {
			Assert.isTrue(timer.running);
			Assert.isTrue(timer.currentCount == 1 || timer.currentCount == 2 || timer.currentCount == 3); // TODO: timer resolution?
		}, 500);

		var m_timer = massive.munit.util.Timer.delay(handler, 250);
	}
	#end

	@Test public function delay() {
		var timer = new Timer(123);
		timer.start();

		Assert.areEqual(123, timer.delay);
		Assert.areEqual(true, timer.running);

		timer.delay = 321;

		Assert.areEqual(321, timer.delay);
		Assert.areEqual(true, timer.running);
	}

	@Test public function repeatCount() {
		var timer_default = new Timer(123);

		Assert.areEqual(0, timer_default.repeatCount);

		var timer = new Timer(123, 3);

		Assert.areEqual(3, timer.repeatCount);

		timer.repeatCount = 10;

		Assert.areEqual(10, timer.repeatCount);

		// TODO: Actual timer ticks tests
	}

	#if integration
	@AsyncTest public function repeatCountDuringTimer() {
		var timer = new Timer (100, 5);
		timer.start();
		
		Assert.areEqual(0, timer.currentCount);

		var handler:Dynamic = Async.handler(this, function():Void {
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

	@Test public function running() {
		var timer = new Timer(123);

		Assert.areEqual(false, timer.running);

		timer.start();

		Assert.areEqual(true, timer.running);
	}

	@Test public function reset() {
		var timer = new Timer(123);
		timer.start();

		Assert.areEqual(true, timer.running);

		timer.reset();

		Assert.areEqual(0, timer.currentCount);
		Assert.areEqual(false, timer.running);
	}

	@Test public function start() {
		var timer = new Timer(123);

		Assert.areEqual(false, timer.running);

		timer.start();

		Assert.areEqual(true, timer.running);
	}

	@Test public function stop() {
		var timer = new Timer(123);
		timer.start();

		Assert.areEqual(true, timer.running);

		timer.stop();

		Assert.areEqual(false, timer.running);
	}

}