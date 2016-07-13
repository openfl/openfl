package openfl.display;


import massive.munit.Assert;
import openfl.display.SimpleButton;


class SimpleButtonTest {
	
	
	@Test public function downState () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.downState = new Sprite ();
		var exists = simpleButton.downState;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function enabled () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.enabled;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function hitTestState () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.hitTestState = new Sprite ();
		var exists = simpleButton.hitTestState;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function overState () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.overState = new Sprite ();
		var exists = simpleButton.overState;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function soundTransform () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.soundTransform;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function trackAsMenu () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.trackAsMenu;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function upState () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		simpleButton.upState = new Sprite ();
		var exists = simpleButton.upState;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function useHandCursor () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		var exists = simpleButton.useHandCursor;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var simpleButton = new SimpleButton ();
		
		Assert.isNotNull (simpleButton);
		
	}
	
	
}