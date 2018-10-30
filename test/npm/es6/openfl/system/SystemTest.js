import System from "openfl/system/System";
import * as assert from "assert";


describe ("ES6 | System", function () {
	
	
	it ("totalMemory", function () {
		
		// TODO: Confirm functionality
		
		var exists = System.totalMemory;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("exit", function () {
		
		// TODO: Confirm functionality
		
		var exists = System.exit;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("gc", function () {
		
		// TODO: Confirm functionality
		
		var exists = System.gc;
		
		assert.notEqual (exists, null);
		
	});
	
	
});