package openfl.system;


import massive.munit.Assert;


class ApplicationDomainTest {
	
	
	@Test public function parentDomain () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.parentDomain;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		Assert.isNotNull (applicationDomain);
		
	}
	
	
	@Test public function getDefinition () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.getDefinition;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function hasDefinition () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.hasDefinition;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function currentDomain () {
		
		// TODO: Confirm functionality
		
		var exists = ApplicationDomain.currentDomain;
		
		Assert.isNotNull (exists);
		
	}
	
	
}