import KeyboardEvent from "openfl/events/KeyboardEvent";
import * as assert from "assert";


describe ("ES6 | KeyboardEvent", function () {
	
	
	it ("altKey", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.altKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("charCode", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.charCode;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("ctrlKey", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.ctrlKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("keyCode", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.keyCode;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("shiftKey", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.shiftKey;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		assert.notEqual (keyboardEvent, null);
		
	});
	
	
});