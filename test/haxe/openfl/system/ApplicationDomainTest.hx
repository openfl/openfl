package openfl.system;


class ApplicationDomainTest { public static function __init__ () { Mocha.describe ("Haxe | ApplicationDomain", function () {
	
	
	Mocha.it ("parentDomain", function () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.parentDomain;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		Assert.notEqual (applicationDomain, null);
		
	});
	
	
	Mocha.it ("getDefinition", function () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.getDefinition;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("hasDefinition", function () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.hasDefinition;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("currentDomain", function () {
		
		// TODO: Confirm functionality
		
		var exists = ApplicationDomain.currentDomain;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}