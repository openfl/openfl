package openfl.events;


import openfl.display.Sprite;


class TouchEventTest { public static function __init__ () { Mocha.describe ("Haxe | TouchEvent", function () {
	
	
	Mocha.it ("altKey", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.altKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("ctrlKey", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.ctrlKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("isPrimaryTouchPoint", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.isPrimaryTouchPoint;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("localX", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.localX;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("localY", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.localY;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("pressure", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.pressure;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("relatedObject", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		touchEvent.relatedObject = new Sprite ();
		var exists = touchEvent.relatedObject;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("shiftKey", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.shiftKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("sizeX", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.sizeX;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("sizeY", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.sizeY;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("stageX", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.stageX;
		
		Assert.assert (Math.isNaN (exists));
		
	});
	
	
	Mocha.it ("stageY", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.stageY;
		
		Assert.assert (Math.isNaN (exists));
		
	});
	
	
	Mocha.it ("touchPointID", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.touchPointID;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		Assert.notEqual (touchEvent, null);
		
	});
	
	
	Mocha.it ("updateAfterEvent", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.updateAfterEvent;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}