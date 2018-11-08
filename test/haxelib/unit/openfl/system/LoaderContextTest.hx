package openfl.system;


import massive.munit.Assert;


class LoaderContextTest {
	
	
	@Test public function allowCodeImport () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.allowCodeImport;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function allowLoadBytesCodeExecution () {
		
		#if !flash // not available in Linux Flash Player
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.allowLoadBytesCodeExecution;
		
		Assert.isNotNull (exists);
		
		#end
		
	}
	
	
	@Test public function applicationDomain () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.applicationDomain;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function checkPolicyFile () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.checkPolicyFile;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function securityDomain () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.securityDomain;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		Assert.isNotNull (loaderContext);
		
	}
	
	
}