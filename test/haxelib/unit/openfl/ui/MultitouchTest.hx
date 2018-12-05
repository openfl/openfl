package openfl.ui;


import massive.munit.Assert;


class MultitouchTest {
	
	
	@Test public function inputMode () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.inputMode;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function maxTouchPoints () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.inputMode;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function supportedGestures () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.supportedGestures;
		
		// Is null if not supported
		//Assert.isNotNull (exists);
		
	}
	
	
	@Test public function supportsGestureEvents () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.supportsGestureEvents;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function supportsTouchEvents () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.supportsTouchEvents;
		
		Assert.isNotNull (exists);
		
	}
	
	
}