import SecurityErrorEvent from "openfl/events/SecurityErrorEvent";
import * as assert from "assert";


describe ("ES6 | SecurityErrorEvent", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var securityErrorEvent = new SecurityErrorEvent (SecurityErrorEvent.SECURITY_ERROR);
		assert.notEqual (securityErrorEvent, null);
		
	});
	
	
});