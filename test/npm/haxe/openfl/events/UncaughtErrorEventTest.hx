package openfl.events;


class UncaughtErrorEventTest { public static function __init__ () { Mocha.describe ("Haxe | UncaughtErrorEvent", function () {
	
	
	Mocha.it ("info", function () {
		
		// TODO: Confirm functionality
		
		var uncaughtErrorEvent = new UncaughtErrorEvent (UncaughtErrorEvent.UNCAUGHT_ERROR);
		var exists = uncaughtErrorEvent.error;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var uncaughtErrorEvent = new UncaughtErrorEvent (UncaughtErrorEvent.UNCAUGHT_ERROR);
		
		Assert.notEqual (uncaughtErrorEvent, null);
		
	});
	
	
}); }}