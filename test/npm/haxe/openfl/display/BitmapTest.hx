package openfl.display;


class BitmapTest { public static function __init__ () { Mocha.describe ("Haxe | Bitmap", function () {
	
	
	Mocha.it ("bitmapData", function () {
		
		var bitmapData = new BitmapData (100, 100, false, 0xFF0000);
		var bitmap = new Bitmap ();
		
		Assert.equal (bitmap.bitmapData, null);
		Assert.equal (bitmap.width, 0);
		Assert.equal (bitmap.height, 0);
		
		bitmap.bitmapData = bitmapData;
		
		Assert.equal (bitmap.bitmapData, bitmapData);
		Assert.equal (bitmap.width, 100);
		Assert.equal (bitmap.height, 100);
		
		bitmap.bitmapData = null;
		
		Assert.equal (bitmap.width, 0);
		Assert.equal (bitmap.height, 0);
		
		bitmap = new Bitmap (bitmapData);
		
		Assert.equal (bitmap.bitmapData, bitmapData);
		
	});
	
	
	Mocha.it ("pixelSnapping", function () {
		
		var bitmap = new Bitmap ();
		
		Assert.equal (PixelSnapping.AUTO, bitmap.pixelSnapping);
		
		bitmap.pixelSnapping = PixelSnapping.ALWAYS;
		
		Assert.equal (PixelSnapping.ALWAYS, bitmap.pixelSnapping);
		
		bitmap = new Bitmap (null, PixelSnapping.NEVER);
		
		Assert.equal (PixelSnapping.NEVER, bitmap.pixelSnapping);
		
	});
	
	
	Mocha.it ("smoothing", function () {
		
		var bitmap = new Bitmap ();
		
		Assert.assert (!bitmap.smoothing);
		
		bitmap.smoothing = true;
		
		Assert.assert (bitmap.smoothing);
		
		bitmap = new Bitmap (null, PixelSnapping.AUTO, true);
		
		Assert.assert (bitmap.smoothing);
		
		var bitmapData = new BitmapData (1, 1);
		bitmap.bitmapData = bitmapData;
		
		Assert.assert (!bitmap.smoothing);
		
		bitmap.smoothing = true;
		
		Assert.assert (bitmap.smoothing);
		
		bitmap.bitmapData = bitmapData;
		
		Assert.assert (!bitmap.smoothing);
		
		bitmap.smoothing = true;
		bitmap.bitmapData = new BitmapData (1, 1);
		
		Assert.assert (!bitmap.smoothing);
		
	});
	
	
}); }}