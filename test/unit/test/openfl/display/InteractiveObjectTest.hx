package openfl.display;


import massive.munit.Assert;
import openfl.display.InteractiveObject;
import openfl.geom.Rectangle;


class InteractiveObjectTest {
	
	
	@Test public function doubleClickEnabled () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.doubleClickEnabled;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function focusRect () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.focusRect;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function mouseEnabled () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.mouseEnabled;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function needsSoftKeyboard () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.needsSoftKeyboard;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function softKeyboardInputAreaOfInterest () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.softKeyboardInputAreaOfInterest;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function tabEnabled () {
		
		var sprite = new Sprite ();
		Assert.isFalse (sprite.tabEnabled);
		
		sprite.buttonMode = true;
		Assert.isTrue (sprite.tabEnabled);
		
		sprite.tabEnabled = false;
		Assert.isFalse (sprite.tabEnabled);
		
		sprite.buttonMode = false;
		sprite.buttonMode = true;
		Assert.isFalse (sprite.tabEnabled);
		
		sprite.tabEnabled = true;
		Assert.isTrue (sprite.tabEnabled);
		
	}
	
	
	@Test public function tabIndex () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.tabIndex;
		
		//Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		
		Assert.isNotNull (sprite);
		
	}
	
	
	@Test public function requestSoftKeyboard () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.requestSoftKeyboard;
		
		Assert.isNotNull (exists);
		
	}
	
	
}