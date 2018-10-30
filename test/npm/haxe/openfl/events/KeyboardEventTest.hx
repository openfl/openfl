package openfl.events;


class KeyboardEventTest { public static function __init__ () { Mocha.describe ("Haxe | KeyboardEvent", function () {
	
	
	Mocha.it ("altKey", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.altKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("charCode", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.charCode;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("ctrlKey", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.ctrlKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("keyCode", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.keyCode;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("shiftKey", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.shiftKey;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		Assert.notEqual (keyboardEvent, null);
		
	});
	
	
}); }}