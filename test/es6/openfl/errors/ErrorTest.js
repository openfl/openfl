import Error from "openfl/errors/Error";
import * as assert from "assert";


describe ("ES6 | Error", function () {
	
	
	it ("errorID", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.errorID;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("message", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.message;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("name", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.name;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		
		assert.notEqual (error, null);
		
	});
	
	
	it ("getStackTrace", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.getStackTrace;
		
		assert.notEqual (exists, null);
		
	});
	
	
});