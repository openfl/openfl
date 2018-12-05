package openfl.system;


class SecurityDomainTest { public static function __init__ () { Mocha.describe ("Haxe | SecurityDomain", function () {
	
	
	Mocha.it ("currentDomain", function () {
		
		// TODO: Confirm functionality
		
		var exists = SecurityDomain.currentDomain;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}