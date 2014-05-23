package openfl.system;


import massive.munit.Assert;


class CapabilitiesTest {
	
	
	@Test public function language () {
		
		// TODO: Confirm functionality
		
		var exists = Capabilities.language;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function screenDPI () {
		
		// TODO: Confirm functionality
		
		var exists = Capabilities.screenDPI;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function screenResolutionX () {
		
		// TODO: Confirm functionality
		
		var exists = Capabilities.screenResolutionX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function screenResolutionY () {
		
		// TODO: Confirm functionality
		
		var exists = Capabilities.screenResolutionY;
		
		Assert.isNotNull (exists);
		
	}
	
	
}