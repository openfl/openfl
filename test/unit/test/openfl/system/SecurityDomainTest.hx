package openfl.system;


import massive.munit.Assert;


class SecurityDomainTest {
	
	
	@Test public function currentDomain () {
		
		// TODO: Confirm functionality
		
		var exists = SecurityDomain.currentDomain;
		
		Assert.isNotNull (exists);
		
	}
	
	
}