package openfl.events;


import massive.munit.Assert;


class UncaughtErrorEventTest {
	
	
	@Test public function info () {
		
		// TODO: Confirm functionality
		
		var uncaughtErrorEvent = new UncaughtErrorEvent (UncaughtErrorEvent.UNCAUGHT_ERROR);
		var exists = uncaughtErrorEvent.error;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var uncaughtErrorEvent = new UncaughtErrorEvent (UncaughtErrorEvent.UNCAUGHT_ERROR);
		
		Assert.isNotNull (uncaughtErrorEvent);
		
	}
	
	
}