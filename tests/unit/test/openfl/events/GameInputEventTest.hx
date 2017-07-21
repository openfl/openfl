package openfl.events;


import massive.munit.Assert;


class GameInputEventTest {
	
	
	@Test public function device () {
		
		// TODO: Confirm functionality
		
		var gameInputEvent = new GameInputEvent (GameInputEvent.DEVICE_ADDED);
		var exists = gameInputEvent.device;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var gameInputEvent = new GameInputEvent (GameInputEvent.DEVICE_ADDED);
		
		Assert.isNotNull (gameInputEvent);
		
	}
	
	
}