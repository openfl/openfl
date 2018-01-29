package openfl.events;


import massive.munit.Assert;


class SecurityErrorEventTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var securityErrorEvent = new SecurityErrorEvent (SecurityErrorEvent.SECURITY_ERROR);
		Assert.isNotNull (securityErrorEvent);
		
	}
	
	
}