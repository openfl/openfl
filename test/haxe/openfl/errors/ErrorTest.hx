package openfl.errors;


class ErrorTest { public static function __init__ () { Mocha.describe ("Haxe | Error", function () {
	
	
	Mocha.it ("errorID", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.errorID;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("message", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.message;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("name", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.name;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		
		Assert.notEqual (error, null);
		
	});
	
	
	Mocha.it ("getStackTrace", function () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.getStackTrace;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}