package openfl.events;


import massive.munit.Assert;


class ErrorEventTest {
	
	
	@Test public function errorID () {
		
		// TODO: Confirm functionality
		
		var errorEvent = new ErrorEvent (ErrorEvent.ERROR);
		var exists = errorEvent.errorID;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var errorEvent = new ErrorEvent (ErrorEvent.ERROR);
		Assert.isNotNull (errorEvent);
		
	}
	
	
}