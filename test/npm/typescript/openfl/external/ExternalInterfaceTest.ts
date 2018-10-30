import ExternalInterface from "openfl/external/ExternalInterface";
import * as assert from "assert";


describe ("TypeScript | ExternalInterface", function () {
	
	
	it ("available", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.available;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("marshallExceptions", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.marshallExceptions;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("objectID", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.objectID;
		
		// Might be defined if running IE
		//assert.equal (exists, null);
		
	});
	
	
	it ("addCallback", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.addCallback;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("call", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.call;
		
		assert.notEqual (exists, null);
		
	});
	
	
});