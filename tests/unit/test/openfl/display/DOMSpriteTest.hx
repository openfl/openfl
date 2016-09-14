package openfl.display;


import massive.munit.Assert;
import openfl.display.DOMSprite;


class DOMSpriteTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var domSprite = new DOMSprite (null);
		var exists = domSprite;
		
		Assert.isNotNull (exists);
		
	}
	
	
}