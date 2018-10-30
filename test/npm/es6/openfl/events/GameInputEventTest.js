import GameInputEvent from "openfl/events/GameInputEvent";
import * as assert from "assert";


describe ("ES6 | GameInputEvent", function () {
	
	
	it ("device", function () {
		
		// TODO: Confirm functionality
		
		var gameInputEvent = new GameInputEvent (GameInputEvent.DEVICE_ADDED);
		var exists = gameInputEvent.device;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var gameInputEvent = new GameInputEvent (GameInputEvent.DEVICE_ADDED);
		
		assert.notEqual (gameInputEvent, null);
		
	});
	
	
});