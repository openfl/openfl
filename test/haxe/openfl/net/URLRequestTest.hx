package openfl.net;


class URLRequestTest { public static function __init__ () { Mocha.describe ("Haxe | URLRequest", function () {
	
	
	Mocha.it ("contentType", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.contentType;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("data", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.data;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("method", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.method;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("requestHeaders", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.requestHeaders;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("url", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		var exists = urlRequest.url;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("userAgent", function () {
		
		// TODO: Confirm functionality
		
		#if !flash
		var urlRequest = new URLRequest ();
		var exists = urlRequest.userAgent;
		
		Assert.equal (exists, null);
		#end
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlRequest = new URLRequest ();
		Assert.notEqual (urlRequest, null);
		
	});
	
	
}); }}