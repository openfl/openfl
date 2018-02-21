package openfl.errors;


class SecurityErrorTest { public static function __init__ () { Mocha.describe ("Haxe | SecurityError", function () {
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var securityError = new SecurityError ();
		Assert.notEqual (securityError, null);
		
	});
	
	
}); }}