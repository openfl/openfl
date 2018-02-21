package openfl.net;


class URLLoaderTest { public static function __init__ () { Mocha.describe ("Haxe | URLLoader", function () {
	
	
	Mocha.it ("bytesLoaded", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.bytesLoaded;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("bytesTotal", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.bytesTotal;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("data", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.data;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("dataFormat", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.dataFormat;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		Assert.notEqual (urlLoader, null);
		
	});
	
	
	Mocha.it ("close", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.close;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("load", function () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.load;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}