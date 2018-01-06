package openfl.events;


import openfl.display.Sprite;


class MouseEventTest { public static function __init__ () { Mocha.describe ("Haxe | MouseEvent", function () {
	
	
	Mocha.it ("altKey", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.altKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("buttonDown", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.buttonDown;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("ctrlKey", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.ctrlKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("delta", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.delta;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("localX", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localX;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("localY", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localY;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("relatedObject", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		mouseEvent.relatedObject = new Sprite ();
		var exists = mouseEvent.relatedObject;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("shiftKey", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.shiftKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("stageX", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageX;
		
		Assert.assert (Math.isNaN (exists));
		
	});
	
	
	Mocha.it ("stageY", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageY;
		
		Assert.assert (Math.isNaN (exists));
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		Assert.notEqual (mouseEvent, null);
		
	});
	
	
	Mocha.it ("updateAfterEvent", function () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.updateAfterEvent;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}