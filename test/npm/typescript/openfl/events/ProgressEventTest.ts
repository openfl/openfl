import ProgressEvent from "openfl/events/ProgressEvent";
import * as assert from "assert";


describe ("TypeScript | ProgressEvent", function () {
	
	
	it ("bytesLoaded", function () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		var exists = progressEvent.bytesLoaded;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("bytesTotal", function () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		var exists = progressEvent.bytesTotal;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		assert.notEqual (progressEvent, null);
		
	});
	
	
});