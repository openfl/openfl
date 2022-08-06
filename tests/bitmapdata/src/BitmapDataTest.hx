package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Sprite;
import openfl.filters.GlowFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import utest.Assert;
import utest.Test;

@:access(openfl.display.BitmapData)
class BitmapDataTest extends Test
{
	#if flash
	@Ignored
	#end
	public function test_fromBase64()
	{
		Assert.notNull(BitmapData.fromBase64);
	}

	public function test_fromBytes()
	{
		Assert.notNull(BitmapData.fromBytes);
	}

	#if (!js || !html5)
	@Ignored
	#end
	public function test_fromCanvas()
	{
		#if (js && html5)
		Assert.notNull(BitmapData.fromCanvas);
		#end
	}

	public function test_fromFile()
	{
		Assert.notNull(BitmapData.fromFile);
	}

	#if !lime
	@Ignored
	#end
	public function test_fromImage()
	{
		#if lime
		Assert.notNull(BitmapData.fromImage);
		#end
	}

	public function test_new_()
	{
		var bitmapData = new BitmapData(100, 100, true, 0xFFFF0000);

		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(0, 0)));

		bitmapData = new BitmapData(100, 100);

		Assert.equals(hex(0xFFFFFFFF), hex(bitmapData.getPixel32(0, 0)));
	}

	#if !flash
	@Ignored
	#end
	public function test_applyFilter()
	{
		// TODO: Test more filters

		var filter = new GlowFilter(0xFFFF0000, 1, 10, 10, 100);

		var bitmapData = new BitmapData(100, 100, true, 0xFFFF0000);
		var bitmapData2 = new BitmapData(100, 100);
		bitmapData2.applyFilter(bitmapData, bitmapData.rect, new Point(), filter);

		Assert.equals(hex(0xFFFF0000), hex(bitmapData2.getPixel32(1, 1)));

		var filterRect = bitmapData2.generateFilterRect(bitmapData2.rect, filter);

		Assert.isTrue(filterRect.width > 100 && filterRect.width <= 115);
		Assert.isTrue(filterRect.height > 100 && filterRect.height <= 115);
	}

	public function test_clone()
	{
		var bitmapData = new BitmapData(100, 100);
		var bitmapData2 = bitmapData.clone();

		Assert.notEquals(bitmapData, bitmapData2);
		Assert.equals(bitmapData.width, bitmapData2.width);
		Assert.equals(bitmapData.height, bitmapData2.height);
		Assert.equals(bitmapData.transparent, bitmapData2.transparent);
		Assert.equals(bitmapData.getPixel32(0, 0), bitmapData2.getPixel32(0, 0));

		var bitmapData = new BitmapData(100, 100, false, 0x00FF0000);
		var bitmapData2 = bitmapData.clone();

		Assert.notEquals(bitmapData, bitmapData2);
		Assert.equals(bitmapData.width, bitmapData2.width);
		Assert.equals(bitmapData.height, bitmapData2.height);
		Assert.equals(bitmapData.transparent, bitmapData2.transparent);
		Assert.equals(bitmapData.getPixel32(0, 0), bitmapData2.getPixel32(0, 0));
	}

	public function test_colorTransform()
	{
		var colorTransform = new ColorTransform(0, 0, 0, 1, 0xFF, 0, 0, 0);

		var bitmapData = new BitmapData(100, 100);
		bitmapData.colorTransform(new Rectangle(0, 0, 50, 50), colorTransform);

		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(0, 0)));
		Assert.equals(hex(0xFFFFFFFF), hex(bitmapData.getPixel32(50, 50)));

		bitmapData = new BitmapData(100, 100);
		bitmapData.colorTransform(bitmapData.rect, colorTransform);

		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(0, 0)));
		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(50, 50)));

		// premultiplied

		#if !flash
		var colorTransform = new ColorTransform(0, 0, 0, 1, 0xFF, 0, 0, 0);

		var bitmapData = new BitmapData(100, 100);
		bitmapData.image.premultiplied = true;
		bitmapData.colorTransform(new Rectangle(0, 0, 50, 50), colorTransform);

		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(0, 0)));
		Assert.equals(hex(0xFFFFFFFF), hex(bitmapData.getPixel32(50, 50)));

		bitmapData = new BitmapData(100, 100);
		bitmapData.image.premultiplied = true;
		bitmapData.colorTransform(bitmapData.rect, colorTransform);

		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(0, 0)));
		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(50, 50)));

		var colorTransform = new ColorTransform(0, 0, 0, 1, 0x88, 0, 0, 0);

		var bitmapData = new BitmapData(100, 100);
		bitmapData.image.premultiplied = true;
		bitmapData.colorTransform(new Rectangle(0, 0, 50, 50), colorTransform);

		Assert.equals(hex(0xFF880000), hex(bitmapData.getPixel32(0, 0)));
		Assert.equals(hex(0xFFFFFFFF), hex(bitmapData.getPixel32(50, 50)));
		#end
	}

	public function test_compare()
	{
		var bitmapData = new BitmapData(50, 50, true, 0xFFFF8800);
		var bitmapData2 = new BitmapData(50, 50, true, 0xFFCC6600);
		// var bitmapData2 = new BitmapData (50, 50, true, 0xCCCC6600);
		var bitmapData3:BitmapData = cast bitmapData.compare(bitmapData2);

		// Assert.equals (hex (0xFF8800), hex (bitmapData.getPixel (0, 0)));
		// Assert.equals (hex (0xFFFF8800), hex (bitmapData.getPixel32 (0, 0)));
		// Assert.equals (hex (0xCC6600), hex (bitmapData.getPixel (0, 0)));
		// Assert.equals (hex (0xCCCC6600), hex (bitmapData.getPixel32 (0, 0)));

		Assert.equals(hex(0x332200), hex(bitmapData3.getPixel(0, 0)));

		bitmapData = new BitmapData(50, 50, true, 0xFFFFAA00);
		bitmapData2 = new BitmapData(50, 50, true, 0xCCFFAA00);
		bitmapData3 = cast bitmapData.compare(bitmapData2);

		Assert.equals(hex(0x33FFFFFF), hex(bitmapData3.getPixel32(0, 0)));

		bitmapData = new BitmapData(50, 50, false, 0xFFFF0000);
		bitmapData2 = new BitmapData(50, 50, false, 0xFFFF0000);

		Assert.equals(0, bitmapData.compare(bitmapData));
		Assert.equals(0, bitmapData.compare(bitmapData2));

		bitmapData = new BitmapData(50, 50);
		bitmapData2 = new BitmapData(60, 50);

		Assert.equals(-3, bitmapData.compare(bitmapData2));

		bitmapData = new BitmapData(50, 50);
		bitmapData2 = new BitmapData(60, 60);

		Assert.equals(-3, bitmapData.compare(bitmapData2));

		bitmapData = new BitmapData(50, 50);
		bitmapData2 = new BitmapData(50, 60);

		Assert.equals(-4, bitmapData.compare(bitmapData2));
	}

	public function test_copyChannel()
	{
		var bitmapData = new BitmapData(100, 100, true, 0xFF000000);
		var bitmapData2 = new BitmapData(100, 100, true, 0xFFFF0000);

		Assert.equals(hex(0xFF000000), hex(bitmapData.getPixel32(0, 0)));
		Assert.equals(hex(0xFFFF0000), hex(bitmapData2.getPixel32(0, 0)));

		bitmapData.copyChannel(bitmapData2, bitmapData2.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.RED);

		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(0, 0)));

		var bitmapData = new BitmapData(100, 100, false);
		var bitmapData2 = new BitmapData(100, 100, true, 0x00FF0000);

		bitmapData.copyChannel(bitmapData2, bitmapData2.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

		Assert.equals(hex(0xFFFFFFFF), hex(bitmapData.getPixel32(0, 0)));

		var bitmapData = new BitmapData(100, 100, true);
		var bitmapData2 = new BitmapData(100, 100, true, 0x22FF0000);

		bitmapData.copyChannel(bitmapData2, bitmapData2.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

		// #if (!flash && !disable_cffi)
		// if (bitmapData.image.premultiplied) {
		//
		// Assert.equals (hex (0x22F7F7F7), hex (bitmapData.getPixel32 (0, 0)));
		//
		// } else
		// #end
		{
			Assert.equals(hex(0x22FFFFFF), hex(bitmapData.getPixel32(0, 0)));
		}

		var bitmapData = new BitmapData(100, 80, false, 0x00FF0000);

		bitmapData.copyChannel(bitmapData, new Rectangle(0, 0, 20, 20), new Point(10, 10), BitmapDataChannel.RED, BitmapDataChannel.BLUE);

		Assert.equals(hex(0xFFFF00FF), hex(bitmapData.getPixel32(10, 10)));
		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(30, 30)));
	}

	public function test_copyPixels()
	{
		var bitmapData = new BitmapData(100, 100);
		var bitmapData2 = new BitmapData(100, 100, true, 0xFFFF0000);

		bitmapData.copyPixels(bitmapData2, bitmapData2.rect, new Point());

		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(0, 0)));

		var bitmapData = new BitmapData(40, 40, false, 0x000000FF);
		var bitmapData2 = new BitmapData(80, 40, false, 0x0000CC44);

		bitmapData2.copyPixels(bitmapData, new Rectangle(0, 0, 20, 20), new Point(10, 10));

		Assert.equals(hex(0xFF00CC44), hex(bitmapData2.getPixel32(0, 0)));
		Assert.equals(hex(0xFF0000FF), hex(bitmapData2.getPixel32(10, 10)));
		Assert.equals(hex(0xFF00CC44), hex(bitmapData2.getPixel32(30, 30)));
	}

	public function test_dispose()
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
		Assert.equals(0, bitmapData.width);
		Assert.equals(0, bitmapData.height);
		#end
	}

	#if hl
	// TODO: fix test on HashLink
	@Ignored
	#end
	public function test_draw()
	{
		var bitmapData = new BitmapData(100, 100);
		var bitmapData2 = new BitmapData(100, 100, true, 0xFF0000FF);

		bitmapData.draw(bitmapData2);

		Assert.equals(hex(0xFF0000FF), hex(bitmapData.getPixel32(0, 0)));

		var bitmapData = new BitmapData(100, 100);
		var bitmap = new Bitmap(new BitmapData(100, 100, true, 0xFF0000FF));

		bitmapData.draw(bitmap);

		Assert.equals(hex(0xFF0000FF), hex(bitmapData.getPixel32(0, 0)));

		var bitmapData = new BitmapData(100, 100, true, 0);
		var bitmap = new Bitmap(new BitmapData(100, 100, true, 0xFF0000FF));
		bitmap.alpha = 0.5;

		bitmapData.draw(bitmap);

		Assert.equals(hex(0xFF0000FF), hex(bitmapData.getPixel32(0, 0)));

		var bitmapData = new BitmapData(100, 100, true, 0);
		var bitmap = new Bitmap(new BitmapData(100, 100, true, 0xFF0000FF));
		var colorTransform = new ColorTransform(1, 1, 1, 0.5);

		bitmapData.draw(bitmap, null, colorTransform);

		Assert.equals(hex(0x7F0000FF), hex(bitmapData.getPixel32(0, 0)));

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xFFFF0000);
		sprite.graphics.drawRect(0, 0, 100, 100);

		bitmapData.draw(sprite);

		Assert.equals(hex(0xFFFF0000), hex(bitmapData.getPixel32(0, 0)));

		var sprite2 = new Sprite();
		sprite2.graphics.beginFill(0x00FF00);
		sprite2.graphics.drawRect(0, 0, 100, 100);

		sprite.x = 50;
		sprite.y = 50;
		sprite2.addChild(sprite);

		bitmapData.draw(sprite2);

		// TODO: Look into software renderer to find why alpha is off by one
		Assert.isTrue(hex(bitmapData.getPixel32(50, 50)) == hex(0xFFFF0000) || hex(bitmapData.getPixel32(50, 50)) == hex(0xFEFF0000));
	}

	#if neko
	@Ignored
	#end
	public function test_drawWithQuality()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(1, 1);
		#if !neko
		var exists = bitmapData.drawWithQuality;
		Assert.notNull(exists);
		#end
	}

	public function test_encode()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.encode;

		Assert.notNull(exists);
	}

	public function test_fillRect()
	{
		var bitmapData = new BitmapData(100, 100);
		bitmapData.fillRect(bitmapData.rect, 0xFFCC8833);

		var pixel = bitmapData.getPixel32(1, 1);
		Assert.equals(StringTools.hex(0xFFCC8833), StringTools.hex(pixel));

		var bitmapData = new BitmapData(100, 100);
		bitmapData.fillRect(new Rectangle(99, 99), 0xFFCC8833);

		var pixel = bitmapData.getPixel32(99, 99);
		Assert.equals(StringTools.hex(0xFFFFFFFF), StringTools.hex(pixel));

		var bitmapData = new BitmapData(100, 100, false);
		bitmapData.fillRect(bitmapData.rect, 0x00CC8833);

		var pixel = bitmapData.getPixel32(0, 0);
		Assert.equals(StringTools.hex(0xFFCC8833), StringTools.hex(pixel));
	}

	public function test_floodFill()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.floodFill;

		Assert.notNull(exists);
	}

	public function test_generateFilterRect()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.generateFilterRect;

		Assert.notNull(exists);
	}

	public function test_getColorBoundsRect()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.getColorBoundsRect;

		Assert.notNull(exists);
	}

	public function test_getPixel()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.getPixel;

		Assert.notNull(exists);
	}

	public function test_getPixel32()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.getPixel32;

		Assert.notNull(exists);
	}

	public function test_getPixels()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(1, 1);
		var exists = bitmapData.getPixels;

		Assert.notNull(exists);
	}

	public function test_getVector()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.getVector;

		Assert.notNull(exists);
	}

	public function test_histogram()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(1, 1);
		var exists = bitmapData.histogram;

		Assert.notNull(exists);
	}

	public function test_hitTest()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(1, 1);
		var exists = bitmapData.hitTest;

		Assert.notNull(exists);
	}

	private function hex(value:Int):String
	{
		return StringTools.hex(value, 8);
	}

	public function test_lock()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.lock;

		Assert.notNull(exists);
	}

	public function test_merge()
	{
		var color = 0xFF000000;
		var color2 = 0xFFFF0000;

		var bitmapData = new BitmapData(100, 100, true, color);
		var sourceBitmapData = new BitmapData(100, 100, true, color2);

		bitmapData.merge(sourceBitmapData, sourceBitmapData.rect, new Point(), 256, 256, 256, 256);

		var pixel = bitmapData.getPixel32(1, 1);
		Assert.equals(StringTools.hex(0xFFFF0000), StringTools.hex(pixel));
	}

	public function test_noise()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.noise;

		Assert.notNull(exists);
	}

	#if neko
	@Ignored
	#end
	public function test_paletteMap()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(1, 1);
		#if !neko
		var exists = bitmapData.paletteMap;

		Assert.notNull(exists);
		#end
	}

	#if neko
	@Ignored
	#end
	public function test_perlinNoise()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		#if !neko
		var exists = bitmapData.perlinNoise;

		Assert.notNull(exists);
		#end
	}

	public function test_scroll()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.scroll;

		Assert.notNull(exists);
	}

	public function test_setPixel()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.setPixel;

		Assert.notNull(exists);
	}

	public function test_setPixel32()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.setPixel32;

		Assert.notNull(exists);
	}

	public function test_setPixels()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.setPixels;

		Assert.notNull(exists);
	}

	public function test_setVector()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.setVector;

		Assert.notNull(exists);
	}

	#if neko
	@Ignored
	#end
	public function test_threshold()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		#if !neko
		var exists = bitmapData.threshold;

		Assert.notNull(exists);
		#end
	}

	public function test_unlock()
	{
		// TODO: Confirm functionality

		var bitmapData = new BitmapData(100, 100);
		var exists = bitmapData.unlock;

		Assert.notNull(exists);
	}

	private static inline var TEST_WIDTH:Int = 100;
	private static inline var TEST_HEIGHT:Int = 100;

	private function getSetPixels(color:Int, sourceAlpha:Bool, destAlpha:Bool)
	{
		var bitmapData = new BitmapData(TEST_WIDTH, TEST_HEIGHT, sourceAlpha, color);
		var pixels = bitmapData.getPixels(bitmapData.rect);

		Assert.equals(TEST_WIDTH * TEST_HEIGHT * 4, pixels.length);

		var expectedColor = color;
		if (sourceAlpha)
		{
			// TODO: Native behavior is different than the flash target here.
			//	   The flash target premultiplies RGB by the alpha value.
			//	   If the native behavior is changed, this test needs to be
			//	   updated.
			if ((expectedColor & 0xFF000000) == 0)
			{
				expectedColor = 0;
			}
		}
		else
		{
			// Surfaces that don't support alpha return FF for the alpha value, so
			// set our expected alpha to FF no matter what the initial value was
			expectedColor |= 0xFF000000;
		}

		var i:Int;
		var pixel:Int;
		pixels.position = 0;

		for (i in 0...Std.int(TEST_WIDTH * TEST_HEIGHT))
		{
			pixel = pixels.readInt();
			Assert.isTrue(Math.abs(((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
			Assert.isTrue(Math.abs(((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
			Assert.isTrue(Math.abs(((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
			Assert.isTrue(Math.abs(((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
		}

		// Now run the same test again to make sure the source
		// did not get changed by reading the first time.
		pixels = bitmapData.getPixels(bitmapData.rect);

		Assert.equals(TEST_WIDTH * TEST_HEIGHT * 4, pixels.length);

		pixels.position = 0;
		for (i in 0...Std.int(TEST_WIDTH * TEST_HEIGHT))
		{
			pixel = pixels.readInt();
			Assert.isTrue(Math.abs(((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
			Assert.isTrue(Math.abs(((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
			Assert.isTrue(Math.abs(((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
			Assert.isTrue(Math.abs(((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
		}

		bitmapData = new BitmapData(TEST_WIDTH, TEST_HEIGHT, destAlpha);

		pixels.position = 0;
		bitmapData.setPixels(bitmapData.rect, pixels);

		var pixel:Int = bitmapData.getPixel32(1, 1);

		if (!destAlpha)
		{
			expectedColor |= 0xFF000000;
		}

		Assert.isTrue(Math.abs(((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
		Assert.isTrue(Math.abs(((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
		Assert.isTrue(Math.abs(((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
		Assert.isTrue(Math.abs(((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
	}

	// There are 6 combinations with an ARGB source that all must be tested:
	//	Fill color: Fully transparent, semi-transparent, fully opaque
	//   Dest bitmap: ARGB or RGB
	// Test each of these using a different test function so we
	// can easily tell which ones fails.
	public function test_testGetAndSetPixelsTransparentARGBToARGB()
	{
		getSetPixels(0x00112233, true, true);
	}

	#if (cpp || neko || hl)
	@Ignored
	#end
	public function test_testGetAndSetPixelsSemiARGBToARGB()
	{
		// TODO: Native targets do not match the flash behavior here.
		//	   If the native target is changed to match flash,
		//	   testGetSetPixels() must be changed to match.
		#if (!cpp && !neko)
		getSetPixels(0x80112233, true, true);
		#end
	}

	public function test_testGetAndSetPixelsOpqaueARGBToARGB()
	{
		getSetPixels(0xFF112233, true, true);
	}

	public function test_testGetAndSetPixelsTransparentARGBToRGB()
	{
		getSetPixels(0x00112233, true, false);
	}

	#if (cpp || neko || hl)
	@Ignored
	#end
	public function test_testGetAndSetPixelsSemiARGBToRGB()
	{
		// TODO
		#if (!cpp && !neko)
		getSetPixels(0x80112233, true, false);
		#end
	}

	public function test_testGetAndSetPixelsOpqaueARGBToRGB()
	{
		getSetPixels(0xFF112233, true, false);
	}

	// There are also 2 combinations with an RGB source that must be tested:
	//   Dest bitmap: ARGB or RGB
	public function test_testGetAndSetPixelsRGBToARGB()
	{
		getSetPixels(0x112233, false, true);
	}

	public function test_testGetAndSetPixelsRGBToRGB()
	{
		getSetPixels(0x112233, false, false);
	}

	/*
		public function test_testDispose () {

			var bitmapData = new BitmapData (100, 100);
			bitmapData.dispose ();

			#if flash

			try {
				bitmapData.width;
			} catch (e:Dynamic) {
				Assert.isTrue (true);
			}

			#elseif neko

			Assert.equals (null, bitmapData.width);
			Assert.equals (null, bitmapData.height);

			#else

			Assert.equals (0, bitmapData.width);
			Assert.equals (0, bitmapData.height);

			#end

		}


		public function test_testDraw () {

			var color = 0xFFFF0000;
			var bitmapData = new BitmapData (100, 100);
			var sourceBitmap = new Bitmap (new BitmapData (100, 100, true, color));

			bitmapData.draw (sourceBitmap);

			var pixel = bitmapData.getPixel32 (1, 1);

			Assert.equals (StringTools.hex (0xFFFF0000, 8), StringTools.hex (pixel, 8));

		}


		#if (cpp || neko)

		public function test_testEncode () {

			var color = 0xFFFF0000;
			var bitmapData = new BitmapData (100, 100, true, color);

			var png = bitmapData.encode ("png");
			bitmapData = BitmapData.loadFromBytes (png);

			var pixel = bitmapData.getPixel32 (1, 1);

			Assert.equals (0xFFFF0000, pixel);

			var jpg = bitmapData.encode ("jpg", 1);
			bitmapData = BitmapData.loadFromBytes (jpg);

			pixel = bitmapData.getPixel32 (1, 1);

			// Since JPG is a lossy format, we need to allow for slightly different values

			Assert.isTrue ((0xFFFF0000 == pixel) || (0xFFFE0000 == pixel));

		}

		#end


		public function test_testColorBoundsRect () {

			var mask = 0xFFFFFFFF;
			var color = 0xFFFFFFFF;

			var bitmapData = new BitmapData (100, 100);

			var colorBoundsRect = bitmapData.getColorBoundsRect (mask, color);

			Assert.equals (100.0, colorBoundsRect.width);
			Assert.equals (100.0, colorBoundsRect.height);

		}


		//@Test
		public function test_HitTest () {

			var bitmapData = new BitmapData (100, 100);

			Assert.isFalse (bitmapData.hitTest (new Point (), 0, new Point (101, 101)));
			Assert.isTrue (bitmapData.hitTest (new Point (), 0, new Point (100, 100)));

		}


		//@Test
		public function test_Merge () {

			#if neko

			var color = { a: 0xFF, rgb: 0x000000 };
			var color2 = { a: 0xFF, rgb: 0xFF0000 };

			#else

			var color = 0xFF000000;
			var color2 = 0xFFFF0000;

			#end

			var bitmapData = new BitmapData (100, 100, true, color);
			var sourceBitmapData = new BitmapData (100, 100, true, color2);

			bitmapData.merge (sourceBitmapData, sourceBitmapData.rect, new Point (), 1, 1, 1, 1);

			var pixel = bitmapData.getPixel32 (1, 1);

			#if neko

			Assert.equals (0xFF, pixel.a);
			Assert.equals (0xFF0000, pixel.rgb);

			#else

			Assert.equals (0xFFFF0000, pixel);

			#end

		}


		public function test_testScroll () {

			var color = 0xFFFF0000;
			var bitmapData = new BitmapData (100, 100);

			bitmapData.fillRect (new Rectangle (0, 0, 100, 10), color);
			bitmapData.scroll (0, 10);

			var pixel = bitmapData.getPixel32 (1, 1);

			Assert.equals (StringTools.hex (0xFFFF0000, 8), StringTools.hex (pixel, 8));

			bitmapData.scroll (0, -20);

			pixel = bitmapData.getPixel32 (1, 1);

			Assert.equals (StringTools.hex (0xFFFFFFFF, 8), StringTools.hex (pixel, 8));

	}*/
	// Properties
	public function test_height()
	{
		var bitmapData = new BitmapData(1, 1);

		Assert.equals(1, bitmapData.height);

		bitmapData = new BitmapData(100, 100, true, 0xFFFF0000);

		Assert.equals(100.0, bitmapData.height);
	}

	public function test_image()
	{
		#if lime
		var bitmapData = new BitmapData(1, 1);
		#if flash
		Assert.isNull(bitmapData.image);
		#else
		Assert.notNull(bitmapData.image);
		#end
		#end
	}

	public function test_rect()
	{
		var bitmapData = new BitmapData(1, 1);

		Assert.equals(0, bitmapData.rect.x);
		Assert.equals(0, bitmapData.rect.y);
		Assert.equals(1, bitmapData.rect.width);
		Assert.equals(1, bitmapData.rect.height);

		bitmapData = new BitmapData(100, 100, true, 0xFFFF0000);

		Assert.equals(0, bitmapData.rect.x);
		Assert.equals(0, bitmapData.rect.y);
		Assert.equals(100.0, bitmapData.rect.width);
		Assert.equals(100.0, bitmapData.rect.height);
	}

	public function test_transparent()
	{
		var bitmapData = new BitmapData(100, 100);

		Assert.isTrue(bitmapData.transparent);
		Assert.equals(hex(0xFFFFFF), hex(bitmapData.getPixel(0, 0)));
		Assert.equals(0xFF, bitmapData.getPixel32(0, 0) >> 24 & 0xFF);

		bitmapData.setPixel32(0, 0, 0x00FFFFFF);

		Assert.equals(0, bitmapData.getPixel32(0, 0) >> 24 & 0xFF);

		bitmapData = new BitmapData(100, 100, false);

		Assert.isFalse(bitmapData.transparent);
		Assert.equals(hex(0xFFFFFF), hex(bitmapData.getPixel(0, 0)));
		Assert.equals(0xFF, bitmapData.getPixel32(0, 0) >> 24 & 0xFF);

		bitmapData.setPixel32(0, 0, 0x00FFFFFF);

		Assert.equals(0xFF, bitmapData.getPixel32(0, 0) >> 24 & 0xFF);

		bitmapData = new BitmapData(100, 100, true);
		bitmapData.setPixel32(0, 0, 0x00FFFFFF);

		var pixels = bitmapData.getPixels(bitmapData.rect);
		pixels.position = 0;

		bitmapData = new BitmapData(100, 100, false);
		bitmapData.setPixels(bitmapData.rect, pixels);

		Assert.equals(0xFF, bitmapData.getPixel32(0, 0) >> 24 & 0xFF);
	}

	public function test_width()
	{
		var bitmapData = new BitmapData(1, 1);

		Assert.equals(1, bitmapData.width);

		bitmapData = new BitmapData(100, 100, true, 0xFFFF0000);

		Assert.equals(100.0, bitmapData.width);
	}
}
