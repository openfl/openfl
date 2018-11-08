package openfl.events;


import massive.munit.Assert;


class KeyboardEventTest {
	
	
	@Test public function altKey () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.altKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function charCode () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.charCode;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function ctrlKey () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.ctrlKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function keyCode () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.keyCode;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function shiftKey () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		var exists = keyboardEvent.shiftKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var keyboardEvent = new KeyboardEvent (KeyboardEvent.KEY_DOWN);
		Assert.isNotNull (keyboardEvent);
		
	}
	
	
}