package openfl.display;

import openfl.filters.GlowFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

@:access(openfl.display.BitmapData)
class BitmapDataTest
{
	#if flash
	@Ignore
	#end
	@Test public function fromBase64()
	{
		Assert.isNotNull(BitmapData.fromBase64);
	}

	@Test public function fromBytes()
	{
		Assert.isNotNull(BitmapData.fromBytes);
	}

	#if (!js || !html5)
	@Ignore
	#end
	@Test public function fromCanvas()
	{
		#if (js && html5)
		Assert.isNotNull(BitmapData.fromCanvas);
		#end
	}

	@Test public function fromFile()
	{
		Assert.isNotNull(BitmapData.fromFile);
	}

	#if !lime
	@Ignore
	#end
	@Test public function fromImage()
	{
		#if lime
		Assert.isNotNull(BitmapData.fromImage);
		#end
	}

	@Test public function new_()
	{
		// Tested in integration

		// var bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);

		// Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));

		// bitmapData = new BitmapData (100, 100);

		// Assert.areEqual (hex (0xFFFFFFFF), hex (bitmapData.getPixel32 (0, 0)));
	}

	#if !flash
	@Ignore
	#end
	@Test public function applyFilter()
	{
		// Tested in integration
	}

	@Test public function clone()
	{
		// Tested in integration
	}

	@Test public function colorTransform()
	{
		// Tested in integration
	}

	@Test public function compare()
	{
		// Tested in integration
	}

	@Test public function copyChannel()
	{
		// Tested in integration
	}

	@Test public function copyPixels()
	{
		// Tested in integration
	}

	@Test public function dispose()
	{
		var bitmapData = new BitmapData(100, 100);
		bitmapData.dispose();

		#if flash
		try
		{
			bitmapData.width;
		}
		catch (e:Dynamic)
		{
			Assert.isTrue(true);
		}
		#else
		Assert.areEqual(0, bitmapData.width);
		Assert.areEqual(0, bitmapData.height);
		#end
	}

	@Test public function draw()
	{
		// Tested in integration
	}

	@Test public function drawWithQuality()
	{
		// Tested in integration
	}

	@Test public function encode()
	{
		// Tested in integration
	}

	@Test public function fillRect()
	{
		// Tested in integration
	}

	@Test public function floodFill()
	{
		// Tested in integration
	}

	@Test public function generateFilterRect()
	{
		// Tested in integration
	}

	@Test public function getColorBoundsRect()
	{
		// Tested in integration
	}

	@Test public function getPixel()
	{
		// Tested in integration
	}

	@Test public function getPixel32()
	{
		// Tested in integration
	}

	@Test public function getPixels()
	{
		// Tested in integration
	}

	@Test public function getVector()
	{
		// Tested in integration
	}

	@Test public function histogram()
	{
		// Tested in integration
	}

	@Test public function hitTest()
	{
		// Tested in integration
	}

	@Test public function lock()
	{
		// Tested in integration
	}

	@Test public function merge()
	{
		// Tested in integration
	}

	@Test public function noise()
	{
		// Tested in integration
	}

	@Test public function paletteMap()
	{
		// Tested in integration
	}

	@Test public function perlinNoise()
	{
		// Tested in integration
	}

	@Test public function scroll()
	{
		// Tested in integration
	}

	@Test public function setPixel()
	{
		// Tested in integration
	}

	@Test public function setPixel32()
	{
		// Tested in integration
	}

	@Test public function setPixels()
	{
		// Tested in integration
	}

	@Test public function setVector()
	{
		// Tested in integration
	}

	@Test public function threshold()
	{
		// Tested in integration
	}

	@Test public function unlock()
	{
		// Tested in integration
	}

	// Properties
	@Test public function height()
	{
		var bitmapData = new BitmapData(1, 1);

		Assert.areEqual(1, bitmapData.height);

		bitmapData = new BitmapData(100, 100, true, 0xFFFF0000);

		Assert.areEqual(100.0, bitmapData.height);
	}

	@Test public function image()
	{
		#if lime
		var bitmapData = new BitmapData(1, 1);
		#if flash
		Assert.isNull(bitmapData.image);
		#else
		Assert.isNotNull(bitmapData.image);
		#end
		#end
	}

	@Test public function rect()
	{
		var bitmapData = new BitmapData(1, 1);

		Assert.areEqual(0, bitmapData.rect.x);
		Assert.areEqual(0, bitmapData.rect.y);
		Assert.areEqual(1, bitmapData.rect.width);
		Assert.areEqual(1, bitmapData.rect.height);

		bitmapData = new BitmapData(100, 100, true, 0xFFFF0000);

		Assert.areEqual(0, bitmapData.rect.x);
		Assert.areEqual(0, bitmapData.rect.y);
		Assert.areEqual(100.0, bitmapData.rect.width);
		Assert.areEqual(100.0, bitmapData.rect.height);
	}

	@Test public function transparent()
	{
		// Tested in integration
	}

	@Test public function width()
	{
		var bitmapData = new BitmapData(1, 1);

		Assert.areEqual(1, bitmapData.width);

		bitmapData = new BitmapData(100, 100, true, 0xFFFF0000);

		Assert.areEqual(100.0, bitmapData.width);
	}
}
