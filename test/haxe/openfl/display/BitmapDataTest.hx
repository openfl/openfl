package openfl.display;


import openfl.filters.GlowFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

@:access(openfl.display.BitmapData)


class BitmapDataTest { public static function __init__ () { Mocha.describe ("Haxe | BitmapData", function () {
	
	
	var hex = function (value:Int):String {
		
		return StringTools.hex (value, 8);
		
	}
	
	
	Mocha.it ("fromBase64", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromBase64;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("fromBytes", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromBytes;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("fromCanvas", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromCanvas;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("fromFile", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromFile;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("fromImage", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromImage;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("height", function () {
		
		var bitmapData = new BitmapData (1, 1);
		
		Assert.equal (bitmapData.height, 1);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.equal (bitmapData.height, 100);
		
	});
	
	
	Mocha.it ("image", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.image;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("rect", function () {
		
		var bitmapData = new BitmapData (1, 1);
		
		Assert.equal (bitmapData.rect.x, 0);
		Assert.equal (bitmapData.rect.y, 0);
		Assert.equal (bitmapData.rect.width, 1);
		Assert.equal (bitmapData.rect.height, 1);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.equal (bitmapData.rect.x, 0);
		Assert.equal (bitmapData.rect.y, 0);
		Assert.equal (bitmapData.rect.width, 100);
		Assert.equal (bitmapData.rect.height, 100);
		
	});
	
	
	Mocha.it ("transparent", function () {
		
		var bitmapData = new BitmapData (100, 100);
		
		Assert.assert (bitmapData.transparent);
		Assert.equal (hex (bitmapData.getPixel (0, 0)), hex (0xFFFFFF));
		Assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0xFF);
		
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		Assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0);
		
		bitmapData = new BitmapData (100, 100, false);
		
		Assert.equal (bitmapData.transparent, false);
		Assert.equal (hex (bitmapData.getPixel (0, 0)), hex (0xFFFFFF));
		Assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0xFF);
		
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		Assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0xFF);
		
		bitmapData = new BitmapData (100, 100, true);
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		var pixels = bitmapData.getPixels (bitmapData.rect);
		pixels.position = 0;
		
		bitmapData = new BitmapData (100, 100, false);
		bitmapData.setPixels (bitmapData.rect, pixels);
		
		Assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0xFF);
		
	});
	
	
	Mocha.it ("width", function () {
		
		var bitmapData = new BitmapData (1, 1);
		
		Assert.equal (bitmapData.width, 1);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.equal (bitmapData.width, 100);
		
	});
	
	
	Mocha.it ("new", function () {
		
		var bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		bitmapData = new BitmapData (100, 100);
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFFFFFF));
		
	});
	
	
	// Mocha.it ("applyFilter", function () {
		
	// 	var filter = new GlowFilter (0xFFFF0000, 1, 10, 10, 100);
		
	// 	var bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
	// 	var bitmapData2 = new BitmapData (100, 100);
	// 	bitmapData2.applyFilter (bitmapData, bitmapData.rect, new Point (), filter);
		
	// 	Assert.equal (hex (bitmapData2.getPixel32 (1, 1)), hex (0xFFFF0000));
		
	// 	var filterRect = bitmapData2.generateFilterRect (bitmapData2.rect, filter);
		
	// 	Assert.assert (filterRect.width > 100 && filterRect.width <= 115);
	// 	Assert.assert (filterRect.height > 100 && filterRect.height <= 115);
		
	// });
	
	
	Mocha.it ("clone", function () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = bitmapData.clone();
		
		Assert.notEqual (bitmapData, bitmapData2);
		Assert.equal (bitmapData.width, bitmapData2.width);
		Assert.equal (bitmapData.height, bitmapData2.height);
		Assert.equal (bitmapData.transparent, bitmapData2.transparent);
		Assert.equal (bitmapData.getPixel32 (0, 0), bitmapData2.getPixel32 (0, 0));
		
		var bitmapData = new BitmapData (100, 100, false, 0x00FF0000);
		var bitmapData2 = bitmapData.clone();
		
		Assert.notEqual (bitmapData, bitmapData2);
		Assert.equal (bitmapData.width, bitmapData2.width);
		Assert.equal (bitmapData.height, bitmapData2.height);
		Assert.equal (bitmapData.transparent, bitmapData2.transparent);
		Assert.equal (bitmapData.getPixel32 (0, 0), bitmapData2.getPixel32 (0, 0));
		
	});
	
	
	Mocha.it ("colorTransform", function () {
		
		var colorTransform = new ColorTransform (0, 0, 0, 1, 0xFF, 0, 0, 0);
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.colorTransform (new Rectangle (0, 0, 50, 50), colorTransform);
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		Assert.equal (hex (bitmapData.getPixel32 (50, 50)), hex (0xFFFFFFFF));
		
		bitmapData = new BitmapData (100, 100);
		bitmapData.colorTransform (bitmapData.rect, colorTransform);
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		Assert.equal (hex (bitmapData.getPixel32 (50, 50)), hex (0xFFFF0000));
		
	});
	
	
	Mocha.it ("compare", function () {
		
		var bitmapData = new BitmapData (50, 50, true, 0xFFFF8800);
		var bitmapData2 = new BitmapData (50, 50, true, 0xFFCC6600);
		//var bitmapData2 = new BitmapData (50, 50, true, 0xCCCC6600);
		var bitmapData3:BitmapData = cast bitmapData.compare (bitmapData2);
		
		//Assert.equal (hex (0xFF8800), hex (bitmapData.getPixel (0, 0)));
		//Assert.equal (hex (0xFFFF8800), hex (bitmapData.getPixel32 (0, 0)));
		//Assert.equal (hex (0xCC6600), hex (bitmapData.getPixel (0, 0)));
		//Assert.equal (hex (0xCCCC6600), hex (bitmapData.getPixel32 (0, 0)));
		
		Assert.equal (hex (bitmapData3.getPixel (0, 0)), hex (0x332200));
		
		bitmapData = new BitmapData (50, 50, true, 0xFFFFAA00);
		bitmapData2 = new BitmapData (50, 50, true, 0xCCFFAA00);
		bitmapData3 = cast bitmapData.compare (bitmapData2);
		
		Assert.equal (hex (bitmapData3.getPixel32 (0, 0)), hex (0x33FFFFFF));
		
		bitmapData = new BitmapData (50, 50, false, 0xFFFF0000);
		bitmapData2 = new BitmapData (50, 50, false, 0xFFFF0000);
		
		Assert.equal (bitmapData.compare (bitmapData), 0);
		Assert.equal (bitmapData.compare (bitmapData2), 0);
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (60, 50);
		
		Assert.equal (bitmapData.compare (bitmapData2), -3);
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (60, 60);
		
		Assert.equal (bitmapData.compare (bitmapData2), -3);
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (50, 60);
		
		Assert.equal (bitmapData.compare (bitmapData2), -4);
		
	});
	
	
	Mocha.it ("copyChannel", function () {
		
		var bitmapData = new BitmapData (100, 100, true, 0xFF000000);
		var bitmapData2 = new BitmapData (100, 100, true, 0xFFFF0000);
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFF000000));
		Assert.equal (hex (bitmapData2.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.RED, BitmapDataChannel.RED);
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		var bitmapData = new BitmapData (100, 100, false);
		var bitmapData2 = new BitmapData (100, 100, true, 0x00FF0000);
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFFFFFF));
		
		var bitmapData = new BitmapData (100, 100, true);
		var bitmapData2 = new BitmapData (100, 100, true, 0x22FF0000);
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		
		//#if (!flash && !disable_cffi)
		//if (bitmapData.image.premultiplied) {
			//
			//Assert.equal (hex (0x22F7F7F7), hex (bitmapData.getPixel32 (0, 0)));
			//
		//} else
		//#end
		{
			
			Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0x22FFFFFF));
			
		}
		
		var bitmapData = new BitmapData (100, 80, false, 0x00FF0000);
		
		bitmapData.copyChannel (bitmapData, new Rectangle (0, 0, 20, 20), new Point (10, 10), BitmapDataChannel.RED, BitmapDataChannel.BLUE);
		
		Assert.equal (hex (bitmapData.getPixel32 (10, 10)), hex (0xFFFF00FF));
		Assert.equal (hex (bitmapData.getPixel32 (30, 30)), hex (0xFFFF0000));
		
	});
	
	
	Mocha.it ("copyPixels", function () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = new BitmapData (100, 100, true, 0xFFFF0000);
		
		bitmapData.copyPixels (bitmapData2, bitmapData2.rect, new Point ());
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		var bitmapData = new BitmapData (40, 40, false, 0x000000FF);
		var bitmapData2 = new BitmapData (80, 40, false, 0x0000CC44);
		
		bitmapData2.copyPixels (bitmapData, new Rectangle (0, 0, 20, 20), new Point (10, 10));
		
		Assert.equal (hex (bitmapData2.getPixel32 (0, 0)), hex (0xFF00CC44));
		Assert.equal (hex (bitmapData2.getPixel32 (10, 10)), hex (0xFF0000FF));
		Assert.equal (hex (bitmapData2.getPixel32 (30, 30)), hex (0xFF00CC44));
		
	});
	
	
	Mocha.it ("copyPixels", function () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = new BitmapData (100, 100, true, 0xFFFF0000);
		
		bitmapData.copyPixels (bitmapData2, bitmapData2.rect, new Point ());
		
		Assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		var bitmapData = new BitmapData (40, 40, false, 0x000000FF);
		var bitmapData2 = new BitmapData (80, 40, false, 0x0000CC44);
		
		bitmapData2.copyPixels (bitmapData, new Rectangle (0, 0, 20, 20), new Point (10, 10));
		
		Assert.equal (hex (bitmapData2.getPixel32 (0, 0)), hex (0xFF00CC44));
		Assert.equal (hex (bitmapData2.getPixel32 (10, 10)), hex (0xFF0000FF));
		Assert.equal (hex (bitmapData2.getPixel32 (30, 30)), hex (0xFF00CC44));
		
	});
	
	
	Mocha.it ("dispose", function () {
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.dispose ();
		
		Assert.equal (bitmapData.width, 0);
		Assert.equal (bitmapData.height, 0);
		
	});
	
	
	Mocha.it ("draw", function () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = new Bitmap (new BitmapData (100, 100, true, 0xFF0000FF));
		
		bitmapData.draw (bitmapData2);
		
		//Assert.equal (hex (0xFF0000FF), hex (bitmapData.getPixel32 (0, 0)));
		
		var sprite = new Sprite ();
		sprite.graphics.beginFill (0xFFFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		bitmapData.draw (sprite);
		
		//Assert.equal (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		
		var sprite2 = new Sprite ();
		sprite2.graphics.beginFill (0x00FF00);
		sprite2.graphics.drawRect (0, 0, 100, 100);
		
		sprite.x = 50;
		sprite.y = 50;
		sprite2.addChild (sprite);
		
		bitmapData.draw (sprite2);
		
		//TODO: Look into software renderer to find why alpha is off by one
		Assert.assert (hex (bitmapData.getPixel32 (50, 50)) == hex (0xFFFF0000) || hex (bitmapData.getPixel32 (50, 50)) == hex (0xFEFF0000));
		
	});
	
	
	Mocha.it ("drawWithQuality", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.drawWithQuality;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("encode", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.encode;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("fillRect", function () {
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.fillRect (bitmapData.rect, 0xFFCC8833);
		
		var pixel = bitmapData.getPixel32 (1, 1);
		Assert.equal (StringTools.hex (pixel), StringTools.hex (0xFFCC8833));
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.fillRect (new Rectangle (99, 99), 0xFFCC8833);
		
		var pixel = bitmapData.getPixel32 (99, 99);
		Assert.equal (StringTools.hex (pixel), StringTools.hex (0xFFFFFFFF));
		
		var bitmapData = new BitmapData (100, 100, false);
		bitmapData.fillRect (bitmapData.rect, 0x00CC8833);
		
		var pixel = bitmapData.getPixel32 (0, 0);
		Assert.equal (StringTools.hex (pixel), StringTools.hex (0xFFCC8833));
		
	});
	
	
	Mocha.it ("floodFill", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.floodFill;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("generateFilterRect", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.generateFilterRect;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getColorBoundsRect", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getColorBoundsRect;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getPixel", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getPixel;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getPixel32", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getPixel32;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getPixels", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.getPixels;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getVector", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getVector;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("histogram", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.histogram;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("hitTest", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.hitTest;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("lock", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.lock;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("merge", function () {
		
		var color = 0xFF000000;
		var color2 = 0xFFFF0000;
		
		var bitmapData = new BitmapData (100, 100, true, color);
		var sourceBitmapData = new BitmapData (100, 100, true, color2);
		
		bitmapData.merge (sourceBitmapData, sourceBitmapData.rect, new Point (), 256, 256, 256, 256);
		
		var pixel = bitmapData.getPixel32 (1, 1);
		Assert.equal (StringTools.hex (pixel), StringTools.hex (0xFFFF0000));
		
	});
	
	
	Mocha.it ("noise", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.noise;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("paletteMap", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.paletteMap;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("perlinNoise", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.perlinNoise;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("scroll", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.scroll;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("setPixel", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixel;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("setPixel32", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixel32;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("setPixels", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixels;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("setVector", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setVector;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("threshold", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.threshold;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("unlock", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.unlock;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	var TEST_WIDTH : Int = 100;
	var TEST_HEIGHT : Int = 100;
	
	var testGetSetPixels = function (color : Int, sourceAlpha: Bool, destAlpha: Bool) {
		var bitmapData = new BitmapData (TEST_WIDTH, TEST_HEIGHT, sourceAlpha, color);
		var pixels = bitmapData.getPixels (bitmapData.rect);
		
		Assert.equal (pixels.length, TEST_WIDTH * TEST_HEIGHT * 4);
		
		var expectedColor = color;
		if (sourceAlpha) {
			
			// TODO: Native behavior is different than the flash target here.
			//	   The flash target premultiplies RGB by the alpha value.
			//	   If the native behavior is changed, this test needs to be
			//	   updated.
			if ((expectedColor & 0xFF000000) == 0) {
				expectedColor = 0;
			}
			
		} else {
			// Surfaces that don't support alpha return FF for the alpha value, so
			// set our expected alpha to FF no matter what the initial value was
			expectedColor |= 0xFF000000;
		}
		
		var i : Int;
		var pixel : Int;
		pixels.position = 0;
		
		for (i in 0...Std.int(TEST_WIDTH * TEST_HEIGHT)) {
			pixel = pixels.readInt();
			Assert.assert (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
			Assert.assert (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
			Assert.assert (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
			Assert.assert (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
		}
		
		// Now run the same test again to make sure the source
		// did not get changed by reading the first time.
		pixels = bitmapData.getPixels (bitmapData.rect);
		
		Assert.equal (pixels.length, TEST_WIDTH * TEST_HEIGHT * 4);
		
		pixels.position = 0;
		for (i in 0...Std.int(TEST_WIDTH * TEST_HEIGHT)) {
			pixel = pixels.readInt();
			Assert.assert (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
			Assert.assert (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
			Assert.assert (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
			Assert.assert (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
		}
		
		bitmapData = new BitmapData (TEST_WIDTH, TEST_HEIGHT, destAlpha);
		
		pixels.position = 0;
		bitmapData.setPixels (bitmapData.rect, pixels);
		
		var pixel:Int = bitmapData.getPixel32 (1, 1);
		
		if (!destAlpha) {
			expectedColor |= 0xFF000000;
		}
		
		Assert.assert (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
		Assert.assert (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
		Assert.assert (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
		Assert.assert (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
	}
	
	// There are 6 combinations with an ARGB source that all must be tested:
	//	Fill color: Fully transparent, semi-transparent, fully opaque
	//   Dest bitmap: ARGB or RGB
	// Test each of these using a different test function so we
	// can easily tell which ones fails.
	Mocha.it ("testGetAndSetPixelsTransparentARGBToARGB", function () {
		testGetSetPixels(0x00112233, true, true);
	});
	
	Mocha.it ("testGetAndSetPixelsSemiARGBToARGB", function () {
		// TODO: Native targets do not match the flash behavior here.
		//	   If the native target is changed to match flash, 
		//	   testGetSetPixels() must be changed to match.
		#if (!cpp && !neko)
		testGetSetPixels(0x80112233, true, true);
		#end
	});
	
	Mocha.it ("testGetAndSetPixelsOpqaueARGBToARGB", function () {
		testGetSetPixels(0xFF112233, true, true);
	});
	
	Mocha.it ("testGetAndSetPixelsTransparentARGBToRGB", function () {
		testGetSetPixels(0x00112233, true, false);
	});
	
	Mocha.it ("testGetAndSetPixelsSemiARGBToRGB", function () {
		// TODO
		#if (!cpp && !neko)
		testGetSetPixels(0x80112233, true, false);
		#end
	});
	
	Mocha.it ("testGetAndSetPixelsOpqaueARGBToRGB", function () {
		testGetSetPixels(0xFF112233, true, false);
	});
	
	// There are also 2 combinations with an RGB source that must be tested:
	//   Dest bitmap: ARGB or RGB
	Mocha.it ("testGetAndSetPixelsRGBToARGB", function () {
		testGetSetPixels(0x112233, false, true);
	});
	
	Mocha.it ("testGetAndSetPixelsRGBToRGB", function () {
		testGetSetPixels(0x112233, false, false);
	});
	
	
}); }}