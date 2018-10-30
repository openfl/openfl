import SecurityError from "openfl/errors/SecurityError";
import * as assert from "assert";


describe ("ES6 | SecurityError", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var securityError = new SecurityError ();
		assert.notEqual (securityError, null);
		
	});
	
	
});