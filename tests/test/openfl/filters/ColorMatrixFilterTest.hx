package openfl.filters;


import massive.munit.Assert;


class ColorMatrixFilterTest {
	
	
	@Test public function matrix () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ();
		var exists = colorMatrixFilter.matrix;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ();
		Assert.isNotNull (colorMatrixFilter);
		
	}
	
	
	@Test public function clone () {
		
		// TODO: Confirm functionality
		
		var colorMatrixFilter = new ColorMatrixFilter ();
		var exists = colorMatrixFilter.clone;
		
		Assert.isNotNull (exists);
		
	}
	
	
}