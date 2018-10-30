import Sprite from "openfl/display/Sprite";
import MouseEvent from "openfl/events/MouseEvent";
import * as assert from "assert";


describe ("TypeScript | MouseEvent", function () {
	
	
	it ("altKey", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.altKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("buttonDown", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.buttonDown;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("ctrlKey", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.ctrlKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("delta", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.delta;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("localX", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localX;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("localY", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localY;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("relatedObject", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		mouseEvent.relatedObject = new Sprite ();
		var exists = mouseEvent.relatedObject;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("shiftKey", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.shiftKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("stageX", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageX;
		
		assert (Number.isNaN (exists));
		
	});
	
	
	it ("stageY", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageY;
		
		assert (Number.isNaN (exists));
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		assert.notEqual (mouseEvent, null);
		
	});
	
	
	it ("updateAfterEvent", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.updateAfterEvent;
		
		assert.notEqual (exists, null);
		
	});
	
	
});