import Capabilities from "openfl/system/Capabilities";
import * as assert from "assert";


describe ("TypeScript | Capabilities", function () {
	
	
	it ("language", function () {
		
		// TODO: Confirm functionality
		
		var exists = Capabilities.language;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("screenDPI", function () {
		
		// TODO: Confirm functionality
		
		var exists = Capabilities.screenDPI;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("screenResolutionX", function () {
		
		// TODO: Confirm functionality
		
		var exists = Capabilities.screenResolutionX;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("screenResolutionY", function () {
		
		// TODO: Confirm functionality
		
		var exists = Capabilities.screenResolutionY;
		
		assert.notEqual (exists, null);
		
	});
	
	
});