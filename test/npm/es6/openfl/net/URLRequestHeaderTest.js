import URLRequestHeader from "openfl/net/URLRequestHeader";
import * as assert from "assert";


describe ("ES6 | URLRequestHeader", function () {
	
	
	it ("name", function () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		var exists = urlRequestHeader.name;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("value", function () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		var exists = urlRequestHeader.value;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		assert.notEqual (urlRequestHeader, null);
		
	});
	
	
});