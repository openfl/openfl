package openfl.external;


class ExternalInterfaceTest { public static function __init__ () { Mocha.describe ("Haxe | ExternalInterface", function () {
	
	
	Mocha.it ("available", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.available;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("marshallExceptions", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.marshallExceptions;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("objectID", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.objectID;
		
		// Might be defined if running IE
		//Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("addCallback", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.addCallback;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("call", function () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.call;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}