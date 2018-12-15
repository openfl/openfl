package openfl.events;


import massive.munit.Assert;


class FullScreenEventTest {
	
	
	@Test public function fullscreen () {
		
		// TODO: Confirm functionality
		
		var fullScreenEvent = new FullScreenEvent (FullScreenEvent.FULL_SCREEN);
		var exists = fullScreenEvent.fullScreen;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function interactive () {
		
		// TODO: Confirm functionality
		
		var fullScreenEvent = new FullScreenEvent (FullScreenEvent.FULL_SCREEN);
		var exists = fullScreenEvent.interactive;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var fullScreenEvent = new FullScreenEvent (FullScreenEvent.FULL_SCREEN);
		
		Assert.isNotNull (fullScreenEvent);
		
	}
	
	
}