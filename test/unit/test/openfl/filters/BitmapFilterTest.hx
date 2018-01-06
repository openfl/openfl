package openfl.filters;


import massive.munit.Assert;


class BitmapFilterTest {
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var bitmapFilter = new BlurFilter ();
		Assert.isNotNull (bitmapFilter);
		
	}
	
	
	@Test public function clone () {
		
		// TODO: Confirm functionality
		
		var bitmapFilter = new BlurFilter ();
		var exists = bitmapFilter.clone;
		
		Assert.isNotNull (exists);
		
	}
	
	
}