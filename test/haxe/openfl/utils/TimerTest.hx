package openfl.utils;


class TimerTest { public static function __init__ () { Mocha.describe ("Haxe | Timer", function () {
	
	
	Mocha.it ("currentCount", function () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.currentCount;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("delay", function () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.delay;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("repeatCount", function () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.repeatCount;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("running", function () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.running;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		Assert.notEqual (timer, null);
		
	});
	
	
	Mocha.it ("reset", function () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.reset;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("start", function () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.start;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("stop", function () {
		
		// TODO: Confirm functionality
		
		var timer = new Timer (0);
		var exists = timer.stop;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}