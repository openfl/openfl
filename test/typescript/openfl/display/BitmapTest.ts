import Bitmap from "openfl/display/Bitmap";
import BitmapData from "openfl/display/BitmapData";
import PixelSnapping from "openfl/display/PixelSnapping";
import * as assert from "assert";


describe ("TypeScript | Bitmap", function () {
	
	
	it ("bitmapData", function () {
		
		var bitmapData = new BitmapData (100, 100, false, 0xFF0000);
		var bitmap = new Bitmap ();
		
		assert.equal (bitmap.bitmapData, null);
		assert.equal (bitmap.width, 0);
		assert.equal (bitmap.height, 0);
		
		bitmap.bitmapData = bitmapData;
		
		assert.equal (bitmap.bitmapData, bitmapData);
		assert.equal (bitmap.width, 100);
		assert.equal (bitmap.height, 100);
		
		bitmap.bitmapData = null;
		
		assert.equal (bitmap.width, 0);
		assert.equal (bitmap.height, 0);
		
		bitmap = new Bitmap (bitmapData);
		
		assert.equal (bitmap.bitmapData, bitmapData);
		
	});
	
	
	it ("pixelSnapping", function () {
		
		var bitmap = new Bitmap ();
		
		assert.equal (PixelSnapping.AUTO, bitmap.pixelSnapping);
		
		bitmap.pixelSnapping = PixelSnapping.ALWAYS;
		
		assert.equal (PixelSnapping.ALWAYS, bitmap.pixelSnapping);
		
		bitmap = new Bitmap (null, PixelSnapping.NEVER);
		
		assert.equal (PixelSnapping.NEVER, bitmap.pixelSnapping);
		
	});
	
	
	it ("smoothing", function () {
		
		var bitmap = new Bitmap ();
		
		assert (!bitmap.smoothing);
		
		bitmap.smoothing = true;
		
		assert (bitmap.smoothing);
		
		bitmap = new Bitmap (null, PixelSnapping.AUTO, true);
		
		assert (bitmap.smoothing);
		
		var bitmapData = new BitmapData (1, 1);
		bitmap.bitmapData = bitmapData;
		
		assert (!bitmap.smoothing);
		
		bitmap.smoothing = true;
		
		assert (bitmap.smoothing);
		
		bitmap.bitmapData = bitmapData;
		
		assert (!bitmap.smoothing);
		
		bitmap.smoothing = true;
		bitmap.bitmapData = new BitmapData (1, 1);
		
		assert (!bitmap.smoothing);
		
	});
	
	
});