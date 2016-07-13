package openfl.filters;


import massive.munit.Assert;


class BlurFilterTest {
	
	
	@Test public function blurX () {
		
		// TODO: Confirm functionality
		
		var blurFilter = new BlurFilter ();
		var exists = blurFilter.blurX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function blurY () {
		
		// TODO: Confirm functionality
		
		var blurFilter = new BlurFilter ();
		var exists = blurFilter.blurY;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function quality () {
		
		// TODO: Confirm functionality
		
		var blurFilter = new BlurFilter ();
		var exists = blurFilter.quality;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var blurFilter = new BlurFilter ();
		Assert.isNotNull (blurFilter);
		
	}
	
	
}