package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import utest.Assert;
import utest.Test;

class BitmapTest extends Test
{
	// Properties
	public function test_bitmapData()
	{
		var bitmapData = new BitmapData(100, 100, false, 0xFF0000);
		var bitmap = new Bitmap();

		Assert.isNull(bitmap.bitmapData);
		Assert.equals(0.0, bitmap.width);
		Assert.equals(0.0, bitmap.height);

		bitmap.bitmapData = bitmapData;

		Assert.equals(bitmap.bitmapData, bitmapData);
		Assert.equals(100.0, bitmap.width);
		Assert.equals(100.0, bitmap.height);

		bitmap.bitmapData = null;

		Assert.equals(0.0, bitmap.width);
		Assert.equals(0.0, bitmap.height);

		bitmap = new Bitmap(bitmapData);

		Assert.equals(bitmap.bitmapData, bitmapData);
	}

	public function test_pixelSnapping()
	{
		var bitmap = new Bitmap();

		Assert.equals(PixelSnapping.AUTO, bitmap.pixelSnapping);

		bitmap.pixelSnapping = PixelSnapping.ALWAYS;

		Assert.equals(PixelSnapping.ALWAYS, bitmap.pixelSnapping);

		bitmap = new Bitmap(null, PixelSnapping.NEVER);

		Assert.equals(PixelSnapping.NEVER, bitmap.pixelSnapping);
	}

	public function test_smoothing()
	{
		var bitmap = new Bitmap();

		Assert.isFalse(bitmap.smoothing);

		bitmap.smoothing = true;

		Assert.isTrue(bitmap.smoothing);

		bitmap = new Bitmap(null, PixelSnapping.AUTO, true);

		Assert.isTrue(bitmap.smoothing);

		var bitmapData = new BitmapData(1, 1);
		bitmap.bitmapData = bitmapData;

		Assert.isFalse(bitmap.smoothing);

		bitmap.smoothing = true;

		Assert.isTrue(bitmap.smoothing);

		bitmap.bitmapData = bitmapData;

		Assert.isFalse(bitmap.smoothing);

		bitmap.smoothing = true;
		bitmap.bitmapData = new BitmapData(1, 1);

		Assert.isFalse(bitmap.smoothing);
	}
}
