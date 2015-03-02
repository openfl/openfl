package openfl.display;

import haxe.PosInfos;
import massive.munit.Assert;
import openfl.filters.GlowFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

@:access(openfl.display.BitmapData)


class BitmapDataTest {
	
	
	@Test public function height () {
		
		var bitmapData = new BitmapData (1, 1);
		
		Assert.areEqual (1, bitmapData.height);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.areEqual (100.0, bitmapData.height);
		
	}
	
	
	@Test public function rect () {
		
		var bitmapData = new BitmapData (1, 1);
		
		Assert.areEqual (0, bitmapData.rect.x);
		Assert.areEqual (0, bitmapData.rect.y);
		Assert.areEqual (1, bitmapData.rect.width);
		Assert.areEqual (1, bitmapData.rect.height);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.areEqual (0, bitmapData.rect.x);
		Assert.areEqual (0, bitmapData.rect.y);
		Assert.areEqual (100.0, bitmapData.rect.width);
		Assert.areEqual (100.0, bitmapData.rect.height);
		
	}
	
	
	@Test public function transparent () {
		
		var bitmapData = new BitmapData (100, 100);
		
		Assert.isTrue (bitmapData.transparent);
		Assert.areEqual (hex (0xFFFFFF), hex (bitmapData.getPixel (0, 0)));
		Assert.areEqual (0xFF, bitmapData.getPixel32 (0, 0) >> 24 & 0xFF);
		
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		Assert.areEqual (0, bitmapData.getPixel32 (0, 0) >> 24 & 0xFF);
		
		bitmapData = new BitmapData (100, 100, false);
		
		Assert.isFalse (bitmapData.transparent);
		Assert.areEqual (hex (0xFFFFFF), hex (bitmapData.getPixel (0, 0)));
		Assert.areEqual (0xFF, bitmapData.getPixel32 (0, 0) >> 24 & 0xFF);
		
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		Assert.areEqual (0xFF, bitmapData.getPixel32 (0, 0) >> 24 & 0xFF);
		
		bitmapData = new BitmapData (100, 100, true);
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		var pixels = bitmapData.getPixels (bitmapData.rect);
		pixels.position = 0;
		
		bitmapData = new BitmapData (100, 100, false);
		bitmapData.setPixels (bitmapData.rect, pixels);
		
		Assert.areEqual (0xFF, bitmapData.getPixel32 (0, 0) >> 24 & 0xFF);
		
	}
	
	
	@Test public function width () {
		
		var bitmapData = new BitmapData (1, 1);
		
		Assert.areEqual (1, bitmapData.width);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.areEqual (100.0, bitmapData.width);
		
	}
	
	
	@Test public function new_ () {
		
		var bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		
		bitmapData = new BitmapData (100, 100);
		
		Assert.areEqual (hex (0xFFFFFFFF), hex (bitmapData.getPixel32 (0, 0)));
		
	}
	
	
	#if (!flash && !lime_legacy) @Ignore #end @Test public function applyFilter () {
		
		#if !html5
		
		//TODO: Test more filters
		
		var filter = new GlowFilter (0xFFFF0000, 1, 10, 10, 100);
		
		var bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		var bitmapData2 = new BitmapData (100, 100);
		bitmapData2.applyFilter (bitmapData, bitmapData.rect, new Point (), filter);
		
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData2.getPixel32 (1, 1)));
		
		var filterRect = bitmapData2.generateFilterRect (bitmapData2.rect, filter);
		
		Assert.isTrue (filterRect.width > 100 && filterRect.width <= 115);
		Assert.isTrue (filterRect.height > 100 && filterRect.height <= 115);
		
		#end
		
	}
	
	
	@Test public function clone () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = bitmapData.clone();
		
		Assert.areNotSame (bitmapData, bitmapData2);
		Assert.areEqual (bitmapData.width, bitmapData2.width);
		Assert.areEqual (bitmapData.height, bitmapData2.height);
		Assert.areEqual (bitmapData.transparent, bitmapData2.transparent);
		Assert.areEqual (bitmapData.getPixel32 (0, 0), bitmapData2.getPixel32 (0, 0));
		
		var bitmapData = new BitmapData (100, 100, false, 0x00FF0000);
		var bitmapData2 = bitmapData.clone();
		
		Assert.areNotSame (bitmapData, bitmapData2);
		Assert.areEqual (bitmapData.width, bitmapData2.width);
		Assert.areEqual (bitmapData.height, bitmapData2.height);
		Assert.areEqual (bitmapData.transparent, bitmapData2.transparent);
		Assert.areEqual (bitmapData.getPixel32 (0, 0), bitmapData2.getPixel32 (0, 0));
		
	}
	
	
	@Test public function colorTransform () {
		
		var colorTransform = new ColorTransform (0, 0, 0, 1, 0xFF, 0, 0, 0);
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.colorTransform (new Rectangle (0, 0, 50, 50), colorTransform);
		
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		Assert.areEqual (hex (0xFFFFFFFF), hex (bitmapData.getPixel32 (50, 50)));
		
		bitmapData = new BitmapData (100, 100);
		bitmapData.colorTransform (bitmapData.rect, colorTransform);
		
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (50, 50)));
		
		// premultiplied
		
		#if (!flash && !lime_legacy)
		var colorTransform = new ColorTransform (0, 0, 0, 1, 0xFF, 0, 0, 0);
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.__image.premultiplied = true;
		bitmapData.colorTransform (new Rectangle (0, 0, 50, 50), colorTransform);
		
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		Assert.areEqual (hex (0xFFFFFFFF), hex (bitmapData.getPixel32 (50, 50)));
		
		bitmapData = new BitmapData (100, 100);
		bitmapData.__image.premultiplied = true;
		bitmapData.colorTransform (bitmapData.rect, colorTransform);
		
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (50, 50)));
		#end
		
	}
	
	
	#if !flash @Ignore #end @Test public function compare () {
		
		#if flash
		
		var bitmapData = new BitmapData (50, 50, true, 0xFFFF8800);
		var bitmapData2 = new BitmapData (50, 50, true, 0xCCCC6600);
		var bitmapData3:BitmapData = cast bitmapData.compare (bitmapData2);
		
		Assert.areEqual (hex (0x332200), hex (bitmapData3.getPixel (0, 0)));
		
		bitmapData = new BitmapData (50, 50, true, 0xFFFFAA00);
		bitmapData2 = new BitmapData (50, 50, true, 0xCCFFAA00);
		bitmapData3 = cast bitmapData.compare (bitmapData2);
		
		Assert.areEqual (hex (0x33FFFFFF), hex (bitmapData3.getPixel32 (0, 0)));
		
		bitmapData = new BitmapData (50, 50, false, 0xFFFF0000);
		bitmapData2 = new BitmapData (50, 50, false, 0xFFFF0000);
		
		Assert.areEqual (0, bitmapData.compare (bitmapData));
		Assert.areEqual (0, bitmapData.compare (bitmapData2));
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (60, 50);
		
		Assert.areEqual (-3, bitmapData.compare (bitmapData2));
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (60, 60);
		
		Assert.areEqual (-3, bitmapData.compare (bitmapData2));
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (50, 60);
		
		Assert.areEqual (-4, bitmapData.compare (bitmapData2));
		
		#end
		
	}
	
	
	@Test public function copyChannel () {
		
		var bitmapData = new BitmapData (100, 100, true, 0xFF000000);
		var bitmapData2 = new BitmapData (100, 100, true, 0xFFFF0000);
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.RED, BitmapDataChannel.RED);
		
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		
		var bitmapData = new BitmapData (100, 100, false);
		var bitmapData2 = new BitmapData (100, 100, true, 0x00FF0000);
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		
		Assert.areEqual (hex (0xFFFFFFFF), hex (bitmapData.getPixel32 (0, 0)));
		
		var bitmapData = new BitmapData (100, 100, true);
		var bitmapData2 = new BitmapData (100, 100, true, 0x22FF0000);
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		
		Assert.areEqual (hex (0x22FFFFFF), hex (bitmapData.getPixel32 (0, 0)));
		
		var bitmapData = new BitmapData (100, 80, false, 0x00FF0000);
		
		bitmapData.copyChannel (bitmapData, new Rectangle (0, 0, 20, 20), new Point (10, 10), BitmapDataChannel.RED, BitmapDataChannel.BLUE);
		
		Assert.areEqual (hex (0xFFFF00FF), hex (bitmapData.getPixel32 (10, 10)));
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (30, 30)));
		
	}
	
	
	@Test public function copyPixels () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = new BitmapData (100, 100, true, 0xFFFF0000);
		
		bitmapData.copyPixels (bitmapData2, bitmapData2.rect, new Point ());
		
		Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		
		var bitmapData = new BitmapData (40, 40, false, 0x000000FF);
		var bitmapData2 = new BitmapData (80, 40, false, 0x0000CC44);
		
		bitmapData2.copyPixels (bitmapData, new Rectangle (0, 0, 20, 20), new Point (10, 10));
		
		Assert.areEqual (hex (0xFF00CC44), hex (bitmapData2.getPixel32 (0, 0)));
		Assert.areEqual (hex (0xFF0000FF), hex (bitmapData2.getPixel32 (10, 10)));
		Assert.areEqual (hex (0xFF00CC44), hex (bitmapData2.getPixel32 (30, 30)));
		
	}
	
	
	@Test public function dispose () {
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.dispose ();
		
		#if flash
		
		try {
			bitmapData.width;
		} catch (e:Dynamic) {
			Assert.isTrue (true);
		}
		
		#else
		
		Assert.areEqual (0, bitmapData.width);
		Assert.areEqual (0, bitmapData.height);
		
		#end
		
	}
	
	
	#if (!flash && !lime_legacy) @Ignore #end @Test public function draw () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = new Bitmap (new BitmapData (100, 100, true, 0xFF0000FF));
		
		bitmapData.draw (bitmapData2);
		
		//Assert.areEqual (hex (0xFF0000FF), hex (bitmapData.getPixel32 (0, 0)));
		
		var sprite = new Sprite ();
		sprite.graphics.beginFill (0xFFFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		bitmapData.draw (sprite);
		
		//Assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		
		var sprite2 = new Sprite ();
		sprite2.graphics.beginFill (0x00FF00);
		sprite2.graphics.drawRect (0, 0, 100, 100);
		
		sprite.x = 50;
		sprite.y = 50;
		sprite2.addChild (sprite);
		
		bitmapData.draw (sprite2);
		
		//TODO: Look into software renderer to find why alpha is off by one
		Assert.isTrue (hex (bitmapData.getPixel32 (50, 50)) == hex (0xFFFF0000) || hex (bitmapData.getPixel32 (50, 50)) == hex (0xFEFF0000));
		
	}
	
	
	@Test public function encode () {
		
		#if !flash // Linux Flash Player does not support this feature
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.encode;
		
		Assert.isNotNull (exists);
		
		#end
		
	}
	
	
	@Test public function fillRect () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.fillRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function floodFill () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.floodFill;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function generateFilterRect () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.generateFilterRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getColorBoundsRect () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getColorBoundsRect;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getPixel () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getPixel;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getPixel32 () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getPixel32;
		
		Assert.isNotNull (exists);
		
	}	
	
	
	@Test public function getVector () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getVector;
		
		Assert.isNotNull (exists);
		
	}
	
	
	private function hex (value:Int):String {
		
		return StringTools.hex (value, 8);
		
	}
	
	
	@Test public function lock () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.lock;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function noise () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.noise;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function perlinNoise () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		#if !neko
		var exists = bitmapData.perlinNoise;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function scroll () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.scroll;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setPixel () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixel;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setPixel32 () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixel32;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setPixels () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixels;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setVector () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setVector;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function threshold () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		#if !neko
		var exists = bitmapData.threshold;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	@Test public function unlock () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.unlock;
		
		Assert.isNotNull (exists);
		
	}
	
    private static inline var TEST_WIDTH : Int = 100;
    private static inline var TEST_HEIGHT : Int = 100;

    private function testGetSetPixels(color : UInt, sourceAlpha: Bool, destAlpha: Bool, ?posinfo : PosInfos) {
		var bitmapData = new BitmapData (TEST_WIDTH, TEST_HEIGHT, sourceAlpha, color);
		var pixels = bitmapData.getPixels (bitmapData.rect);
		
		Assert.areEqual (TEST_WIDTH * TEST_HEIGHT * 4, pixels.length, posinfo);

        var expectedColor = color;
        if (sourceAlpha) {
            // TODO: Native behavior is different than the flash target here.
            //       The flash target premultiplies RGB by the alpha value.
            //       If the native behavior is changed, this test needs to be
            //       updated.
            if ((expectedColor & 0xFF000000) == 0) {
                expectedColor = 0;
            }
        }
        else {
            // Surfaces that don't support alpha return FF for the alpha value, so
            // set our expected alpha to FF no matter what the initial value was
            expectedColor |= 0xFF000000;
        }
        
        var i : Int;
        var pixel : UInt;
        pixels.position = 0;
        
        for (i in 0...Std.int(TEST_WIDTH * TEST_HEIGHT)) {
            pixel = pixels.readUnsignedInt();
            Assert.isTrue (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1, posinfo);
            Assert.isTrue (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1, posinfo);
            Assert.isTrue (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1, posinfo);
            Assert.isTrue (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1, posinfo);
        }

        // Now run the same test again to make sure the source
        // did not get changed by reading the first time.
		pixels = bitmapData.getPixels (bitmapData.rect);
		
		Assert.areEqual (TEST_WIDTH * TEST_HEIGHT * 4, pixels.length, posinfo);

        pixels.position = 0;
        for (i in 0...Std.int(TEST_WIDTH * TEST_HEIGHT)) {
            pixel = pixels.readUnsignedInt();
            Assert.isTrue (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1, posinfo);
            Assert.isTrue (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1, posinfo);
            Assert.isTrue (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1, posinfo);
            Assert.isTrue (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1, posinfo);
        }
        
		bitmapData = new BitmapData (TEST_WIDTH, TEST_HEIGHT, destAlpha);
		
		pixels.position = 0;
		bitmapData.setPixels (bitmapData.rect, pixels);
		
		var pixel = bitmapData.getPixel32 (1, 1);

        if (!destAlpha) {
            expectedColor |= 0xFF000000;
        }
        
        Assert.isTrue (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1, posinfo);
        Assert.isTrue (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1, posinfo);
        Assert.isTrue (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1, posinfo);
        Assert.isTrue (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1, posinfo);
    }

    // There are 6 combinations with an ARGB source that all must be tested:
    //    Fill color: Fully transparent, semi-transparent, fully opaque
    //   Dest bitmap: ARGB or RGB
    // Test each of these using a different test function so we
    // can easily tell which ones fails.
    @Test public function testGetAndSetPixelsTransparentARGBToARGB() {
        testGetSetPixels(0x00112233, true, true);
	}

    @Test public function testGetAndSetPixelsSemiARGBToARGB() {
        // TODO: Native targets do not match the flash behavior here.
        //       If the native target is changed to match flash, 
        //       testGetSetPixels() must be changed to match.
        testGetSetPixels(0x80112233, true, true);
	}
	
    @Test public function testGetAndSetPixelsOpqaueARGBToARGB() {
        testGetSetPixels(0xFF112233, true, true);
	}

    @Test public function testGetAndSetPixelsTransparentARGBToRGB() {
        testGetSetPixels(0x00112233, true, false);
	}

    @Test public function testGetAndSetPixelsSemiARGBToRGB() {
        testGetSetPixels(0x80112233, true, false);
	}
	
    @Test public function testGetAndSetPixelsOpqaueARGBToRGB() {
        testGetSetPixels(0xFF112233, true, false);
	}

    // There are also 2 combinations with an RGB source that must be tested:
    //   Dest bitmap: ARGB or RGB
    @Test public function testGetAndSetPixelsRGBToARGB() {
        testGetSetPixels(0x112233, false, true);
	}

    @Test public function testGetAndSetPixelsRGBToRGB() {
        testGetSetPixels(0x112233, false, false);
	}

    /*
	@Test public function testDispose () {
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.dispose ();
		
		#if flash
		
		try {
			bitmapData.width;
		} catch (e:Dynamic) {
			Assert.isTrue (true);
		}
		
		#elseif neko
		
		Assert.areEqual (null, bitmapData.width);
		Assert.areEqual (null, bitmapData.height);
		
		#else
		
		Assert.areEqual (0, bitmapData.width);
		Assert.areEqual (0, bitmapData.height);
		
		#end
		
	}
	
	
	@Test public function testDraw () {
		
		var color = 0xFFFF0000;
		var bitmapData = new BitmapData (100, 100);
		var sourceBitmap = new Bitmap (new BitmapData (100, 100, true, color));
		
		bitmapData.draw (sourceBitmap);
		
		var pixel = bitmapData.getPixel32 (1, 1);
		
		Assert.areEqual (StringTools.hex (0xFFFF0000, 8), StringTools.hex (pixel, 8));
		
	}
	
	
	#if (cpp || neko)
	
	@Test public function testEncode () {
		
		var color = 0xFFFF0000;
		var bitmapData = new BitmapData (100, 100, true, color);
		
		var png = bitmapData.encode ("png");
		bitmapData = BitmapData.loadFromBytes (png);
		
		var pixel = bitmapData.getPixel32 (1, 1);
		
		Assert.areEqual (0xFFFF0000, pixel);
		
		var jpg = bitmapData.encode ("jpg", 1);
		bitmapData = BitmapData.loadFromBytes (jpg);
		
		pixel = bitmapData.getPixel32 (1, 1);
		
		// Since JPG is a lossy format, we need to allow for slightly different values
		
		Assert.isTrue ((0xFFFF0000 == pixel) || (0xFFFE0000 == pixel));
		
	}
	
	#end
	
	
	@Test public function testColorBoundsRect () {
		
		var mask = 0xFFFFFFFF;
		var color = 0xFFFFFFFF;
		
		var bitmapData = new BitmapData (100, 100);
		
		var colorBoundsRect = bitmapData.getColorBoundsRect (mask, color);
		
		Assert.areEqual (100.0, colorBoundsRect.width);
		Assert.areEqual (100.0, colorBoundsRect.height);
		
	}
	
		
	//@Test
	public function testHitTest () {
		
		var bitmapData = new BitmapData (100, 100);
		
		Assert.isFalse (bitmapData.hitTest (new Point (), 0, new Point (101, 101)));
		Assert.isTrue (bitmapData.hitTest (new Point (), 0, new Point (100, 100)));
		
	}
	
	
	//@Test
	public function testMerge () {
		
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
		
		Assert.areEqual (0xFF, pixel.a);
		Assert.areEqual (0xFF0000, pixel.rgb);
		
		#else
		
		Assert.areEqual (0xFFFF0000, pixel);
		
		#end
		
	}
	
	
	@Test public function testScroll () {
		
		var color = 0xFFFF0000;
		var bitmapData = new BitmapData (100, 100);
		
		bitmapData.fillRect (new Rectangle (0, 0, 100, 10), color);
		bitmapData.scroll (0, 10);
		
		var pixel = bitmapData.getPixel32 (1, 1);
		
		Assert.areEqual (StringTools.hex (0xFFFF0000, 8), StringTools.hex (pixel, 8));
		
		bitmapData.scroll (0, -20);
		
		pixel = bitmapData.getPixel32 (1, 1);
		
		Assert.areEqual (StringTools.hex (0xFFFFFFFF, 8), StringTools.hex (pixel, 8));
		
	}*/
	
	
}
