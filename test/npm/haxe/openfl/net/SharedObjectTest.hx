package openfl.net;


class SharedObjectTest { public static function __init__ () { Mocha.describe ("Haxe | SharedObject", function () {
	
	
	Mocha.it ("data", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.data;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("size", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.size;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		Assert.notEqual (sharedObject, null);
		
	});
	
	
	Mocha.it ("clear", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.clear;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("flush", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.flush;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("setProperty", function () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.setProperty;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getLocal", function () {
		
		// TODO: Confirm functionality
		
		var exists = SharedObject.getLocal;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}