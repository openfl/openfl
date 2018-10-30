import Sprite from "openfl/display/Sprite";
import TouchEvent from "openfl/events/TouchEvent";
import * as assert from "assert";


describe ("TypeScript | TouchEvent", function () {
	
	
	it ("altKey", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.altKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("ctrlKey", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.ctrlKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("isPrimaryTouchPoint", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.isPrimaryTouchPoint;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("localX", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.localX;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("localY", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.localY;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("pressure", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.pressure;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("relatedObject", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		touchEvent.relatedObject = new Sprite ();
		var exists = touchEvent.relatedObject;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("shiftKey", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.shiftKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("sizeX", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.sizeX;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("sizeY", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.sizeY;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("stageX", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.stageX;
		
		assert (Number.isNaN (exists));
		
	});
	
	
	it ("stageY", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.stageY;
		
		assert (Number.isNaN (exists));
		
	});
	
	
	it ("touchPointID", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.touchPointID;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		assert.notEqual (touchEvent, null);
		
	});
	
	
	it ("updateAfterEvent", function () {
		
		// TODO: Confirm functionality
		
		var touchEvent = new TouchEvent (TouchEvent.TOUCH_BEGIN);
		var exists = touchEvent.updateAfterEvent;
		
		assert.notEqual (exists, null);
		
	});
	
	
});