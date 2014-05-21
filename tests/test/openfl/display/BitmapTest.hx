package openfl.display;


import massive.munit.Assert;


class BitmapTest {
	
	
	@Test public function bitmapData () {
		
		var bitmapData = new BitmapData (100, 100, false, 0xFF0000);
		var bitmap = new Bitmap ();
		
		Assert.isNull (bitmap.bitmapData);
		Assert.areEqual (0.0, bitmap.width);
		Assert.areEqual (0.0, bitmap.height);
		
		bitmap.bitmapData = bitmapData;
		
		Assert.areSame (bitmap.bitmapData, bitmapData);
		Assert.areEqual (100.0, bitmap.width);
		Assert.areEqual (100.0, bitmap.height);
		
		bitmap.bitmapData = null;
		
		Assert.areEqual (0.0, bitmap.width);
		Assert.areEqual (0.0, bitmap.height);
		
		bitmap = new Bitmap (bitmapData);
		
		Assert.areSame (bitmap.bitmapData, bitmapData);
		
	}
	
	
	@Test public function pixelSnapping () {
		
		var bitmap = new Bitmap ();
		
		Assert.areEqual (PixelSnapping.AUTO, bitmap.pixelSnapping);
		
		bitmap.pixelSnapping = PixelSnapping.ALWAYS;
		
		Assert.areEqual (PixelSnapping.ALWAYS, bitmap.pixelSnapping);
		
		bitmap = new Bitmap (null, PixelSnapping.NEVER);
		
		Assert.areEqual (PixelSnapping.NEVER, bitmap.pixelSnapping);
		
	}
	
	
	@Test public function smoothing () {
		
		var bitmap = new Bitmap ();
		
		Assert.isFalse (bitmap.smoothing);
		
		bitmap.smoothing = true;
		
		Assert.isTrue (bitmap.smoothing);
		
		bitmap = new Bitmap (null, PixelSnapping.AUTO, true);
		
		Assert.isTrue (bitmap.smoothing);
		
	}
	
	
}
