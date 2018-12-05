import ActivityEvent from "openfl/events/ActivityEvent";
import * as assert from "assert";


describe ("TypeScript | ActivityEvent", function () {
	
	
	it ("activating", function () {
		
		// TODO: Confirm functionality
		
		var activityEvent = new ActivityEvent (ActivityEvent.ACTIVITY);
		var exists = activityEvent.activating;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var activityEvent = new ActivityEvent (ActivityEvent.ACTIVITY);
		
		assert.notEqual (activityEvent, null);
		
	});
	
	
});