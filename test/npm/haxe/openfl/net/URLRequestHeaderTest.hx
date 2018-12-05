package openfl.net;


class URLRequestHeaderTest { public static function __init__ () { Mocha.describe ("Haxe | URLRequestHeader", function () {
	
	
	Mocha.it ("name", function () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		var exists = urlRequestHeader.name;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("value", function () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		var exists = urlRequestHeader.value;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlRequestHeader = new URLRequestHeader ();
		Assert.notEqual (urlRequestHeader, null);
		
	});
	
	
}); }}