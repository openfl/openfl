import HTTPStatusEvent from "openfl/events/HTTPStatusEvent";
import * as assert from "assert";


describe ("TypeScript | HTTPStatusEvent", function () {
	
	
	it ("responseHeaders", function () {
		
		// #if !flash // throws error when not dispatched
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.responseHeaders;
		
		//assert.notEqual (exists, null);
		
		// #end
		
	});
	
	
	it ("responseURL", function () {
		
		// #if !flash // throws error when not dispatched
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.responseURL;
		
		//assert.notEqual (exists, null);
		
		// #end
		
	});
	
	
	it ("status", function () {
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		var exists = httpStatusEvent.status;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		var httpStatusEvent = new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS);
		assert.notEqual (httpStatusEvent, null);
		
	});
	
	
});