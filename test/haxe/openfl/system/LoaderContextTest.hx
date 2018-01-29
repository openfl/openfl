package openfl.system;


class LoaderContextTest { public static function __init__ () { Mocha.describe ("Haxe | LoaderContext", function () {
	
	
	Mocha.it ("allowCodeImport", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.allowCodeImport;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("allowLoadBytesCodeExecution", function () {
		
		#if !flash // not available in Linux Flash Player
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.allowLoadBytesCodeExecution;
		
		Assert.notEqual (exists, null);
		
		#end
		
	});
	
	
	Mocha.it ("applicationDomain", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.applicationDomain;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("checkPolicyFile", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.checkPolicyFile;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("securityDomain", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.securityDomain;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		Assert.notEqual (loaderContext, null);
		
	});
	
	
}); }}