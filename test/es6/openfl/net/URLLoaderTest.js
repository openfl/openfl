import URLLoader from "openfl/net/URLLoader";
import * as assert from "assert";


describe ("ES6 | URLLoader", function () {
	
	
	it ("bytesLoaded", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.bytesLoaded;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("bytesTotal", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.bytesTotal;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("data", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.data;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("dataFormat", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.dataFormat;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		assert.notEqual (urlLoader, null);
		
	});
	
	
	it ("close", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.close;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("load", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.load;
		
		assert.notEqual (exists, null);
		
	});
	
	
});