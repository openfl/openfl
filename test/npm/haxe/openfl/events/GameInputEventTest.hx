package openfl.events;


class GameInputEventTest { public static function __init__ () { Mocha.describe ("Haxe | GameInputEvent", function () {
	
	
	Mocha.it ("device", function () {
		
		// TODO: Confirm functionality
		
		var gameInputEvent = new GameInputEvent (GameInputEvent.DEVICE_ADDED);
		var exists = gameInputEvent.device;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var gameInputEvent = new GameInputEvent (GameInputEvent.DEVICE_ADDED);
		
		Assert.notEqual (gameInputEvent, null);
		
	});
	
	
}); }}