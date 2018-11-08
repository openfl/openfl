import TimerEvent from "openfl/events/TimerEvent";
import * as assert from "assert";


describe ("ES6 | TimerEvent", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var timerEvent = new TimerEvent (TimerEvent.TIMER);
		assert.notEqual (timerEvent, null);
		
	});
	
	
	it ("updateAfterEvent", function () {
		
		// TODO: Confirm functionality
		
		var timerEvent = new TimerEvent (TimerEvent.TIMER);
		var exists = timerEvent.updateAfterEvent;
		
		assert.notEqual (exists, null);
		
	});
	
	
});