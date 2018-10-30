import IOErrorEvent from "openfl/events/IOErrorEvent";
import * as assert from "assert";


describe ("ES6 | IOErrorEvent", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var ioErrorEvent = new IOErrorEvent (IOErrorEvent.IO_ERROR);
		assert.notEqual (ioErrorEvent, null);
		
	});
	
	
});