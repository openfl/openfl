package openfl.system;


class SystemTest { public static function __init__ () { Mocha.describe ("Haxe | System", function () {
	
	
	Mocha.it ("totalMemory", function () {
		
		// TODO: Confirm functionality
		
		var exists = System.totalMemory;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("exit", function () {
		
		// TODO: Confirm functionality
		
		var exists = System.exit;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("gc", function () {
		
		// TODO: Confirm functionality
		
		var exists = System.gc;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}