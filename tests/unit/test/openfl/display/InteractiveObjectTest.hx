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