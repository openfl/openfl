package openfl;

import openfl.display.BitmapData;
import massive.munit.Assert;


class AssetsTest {
	
	
	@Test public function cachedBitmapData () {
		
		
		
	}
	
	
	@Test public function id () {
		
		
		
	}
	
	
	@Test public function library () {
		
		
		
	}
	
	
	@Test public function path () {
		
		
		
	}
	
	
	@Test public function type () {
		
		
		
	}
	
	
	
	@Test public function getBitmapData () {
		
		
		
	}
	
	
	@Test public function getBytes () {
		
		
		
	}
	
	
	@Test public function getFont () {
		
		
		
	}
	
	
	@Test public function getMovieClip () {
		
		
		
	}
	
	
	@Test public function getSound () {
		
		
		
	}
	
	
	@Test public function getText () {
		
		
		
	}
	
	
	#if html5
	@Test public function embedBitmap () {
		
		// When an embedded bitmap is loaded more than once, it should
		// reuse the previously loaded image
		var preload = new BitmapData(1, 1, false, 0);
		MacroPreloadTest.preload = preload.image;
		Assert.areEqual(1, new MacroPreloadTest(0, 0).width);
		
	}
	#end
	
}

#if html5
@:bitmap("openfl/1x1.png") class MacroPreloadTest extends BitmapData { }
#end
