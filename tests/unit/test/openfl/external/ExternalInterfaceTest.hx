package openfl.external;


import massive.munit.Assert;


class ExternalInterfaceTest {
	
	
	@Test public function available () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.available;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function marshallExceptions () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.marshallExceptions;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function objectID () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.objectID;
		
		// Might be defined if running IE
		//Assert.isNull (exists);
		
	}
	
	
	@Test public function addCallback () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.addCallback;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function call () {
		
		// TODO: Confirm functionality
		
		var exists = ExternalInterface.call;
		
		Assert.isNotNull (exists);
		
	}
	
	
}