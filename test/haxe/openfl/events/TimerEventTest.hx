package openfl.events;


class TimerEventTest { public static function __init__ () { Mocha.describe ("Haxe | TimerEvent", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var timerEvent = new TimerEvent (TimerEvent.TIMER);
		Assert.notEqual (timerEvent, null);
		
	});
	
	
	Mocha.it ("updateAfterEvent", function () {
		
		// TODO: Confirm functionality
		
		var timerEvent = new TimerEvent (TimerEvent.TIMER);
		var exists = timerEvent.updateAfterEvent;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}