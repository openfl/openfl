package openfl.display;


import massive.munit.Assert;
import openfl.display.Shape;


class ShapeTest {
	
	
	@Test public function graphics () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		var exists = shape.graphics;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var shape = new Shape ();
		
		Assert.isNotNull (shape);
		
	}
	
	
}