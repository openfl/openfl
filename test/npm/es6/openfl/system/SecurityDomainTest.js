import SecurityDomain from "openfl/system/SecurityDomain";
import * as assert from "assert";


describe ("ES6 | SecurityDomain", function () {
	
	
	it ("currentDomain", function () {
		
		// TODO: Confirm functionality
		
		var exists = SecurityDomain.currentDomain;
		
		assert.notEqual (exists, null);
		
	});
	
	
});