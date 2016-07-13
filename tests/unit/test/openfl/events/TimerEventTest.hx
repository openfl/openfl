package openfl.events;


import massive.munit.Assert;


class TimerEventTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var timerEvent = new TimerEvent (TimerEvent.TIMER);
		Assert.isNotNull (timerEvent);
		
	}
	
	
	@Test public function updateAfterEvent () {
		
		// TODO: Confirm functionality
		
		var timerEvent = new TimerEvent (TimerEvent.TIMER);
		var exists = timerEvent.updateAfterEvent;
		
		Assert.isNotNull (exists);
		
	}
	
	
}