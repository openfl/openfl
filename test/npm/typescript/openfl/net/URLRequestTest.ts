import URLRequest from "openfl/net/URLRequest";
import * as assert from "assert";


describe ("TypeScript | URLRequest", function () {
	
	
	it ("contentType", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.contentType;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("data", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.data;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("method", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.method;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("requestHeaders", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.requestHeaders;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("url", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.url;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("userAgent", function () {
		
		// TODO: Confirm functionality
		
		// #if !flash
		var urlRequest = new URLRequest ();
		var exists = urlRequest.userAgent;
		
		assert.equal (exists, null);
		// #end
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		assert.notEqual (urlRequest, null);
		
	});
	
	
});