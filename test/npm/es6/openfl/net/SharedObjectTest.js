import SharedObject from "openfl/net/SharedObject";
import * as assert from "assert";


describe ("ES6 | SharedObject", function () {
	
	
	it ("data", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.data;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("size", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.size;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		assert.notEqual (sharedObject, null);
		
	});
	
	
	it ("clear", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.clear;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("flush", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.flush;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setProperty", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.setProperty;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getLocal", function () {
		
		// TODO: Confirm functionality
		
		var exists = SharedObject.getLocal;
		
		assert.notEqual (exists, null);
		
	});
	
	
});