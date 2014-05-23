package openfl.display;


import massive.munit.Assert;


class SpriteTest {
	
	
	@Test public function buttonMode () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.buttonMode;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function graphics () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.graphics;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function useHandCursor () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.useHandCursor;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		
		Assert.isNotNull (sprite);
		
	}
	
	
	@Test public function startDrag () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.startDrag;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stopDrag () {
		
		// TODO: Confirm functionality
		
		var sprite = new Sprite ();
		var exists = sprite.stopDrag;
		
		Assert.isNotNull (exists);
		
	}
	
	
}