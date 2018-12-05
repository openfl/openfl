import AsyncErrorEvent from "openfl/events/AsyncErrorEvent";
import * as assert from "assert";


describe ("ES6 | AsyncErrorEvent", function () {
	
	
	it ("error", function () {
		
		// TODO: Confirm functionality
		
		var asyncErrorEvent = new AsyncErrorEvent (AsyncErrorEvent.ASYNC_ERROR);
		var exists = asyncErrorEvent.error;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var asyncErrorEvent = new AsyncErrorEvent (AsyncErrorEvent.ASYNC_ERROR);
		
		assert.notEqual (asyncErrorEvent, null);
		
	});
	
	
});