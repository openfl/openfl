package openfl.utils;


import massive.munit.Assert;


class TimerTest {
	
	
	@Test public function currentCount () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.currentCount;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function delay () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.delay;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function repeatCount () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.repeatCount;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function running () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.running;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		Assert.isNotNull (timer);
		
	}
	
	
	@Test public function reset () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.reset;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function start () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.start;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stop () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.stop;
		
		Assert.isNotNull (exists);
		
	}
	
	
}