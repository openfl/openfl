package openfl.events;


import massive.munit.Assert;


class ActivityEventTest {
	
	
	@Test public function activating () {
		
		// TODO: Confirm functionality
		
		var activityEvent = new ActivityEvent (ActivityEvent.ACTIVITY);
		var exists = activityEvent.activating;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var activityEvent = new ActivityEvent (ActivityEvent.ACTIVITY);
		
		Assert.isNotNull (activityEvent);
		
	}
	
	
}