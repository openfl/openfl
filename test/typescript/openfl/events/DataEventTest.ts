import DataEvent from "openfl/events/DataEvent";
import * as assert from "assert";


describe ("TypeScript | DataEvent", function () {
	
	
	it ("data", function () {
		
		// TODO: Confirm functionality
		
		var dataEvent = new DataEvent (DataEvent.DATA);
		var exists = dataEvent.data;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var dataEvent = new DataEvent (DataEvent.DATA);
		
		assert.notEqual (dataEvent, null);
		
	});
	
	
});