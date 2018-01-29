import GlowFilter from "openfl/filters/GlowFilter";
import ColorTransform from "openfl/geom/ColorTransform";
import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";
import ByteArray from "openfl/utils/ByteArray";
import BitmapData from "openfl/display/BitmapData";
import BitmapDataChannel from "openfl/display/BitmapDataChannel";
import Sprite from "openfl/display/Sprite";
import Bitmap from "openfl/display/Bitmap";
import * as assert from "assert";


describe ("TypeScript | BitmapData", function () {
	
	
	var hex = function (value:number):string {
		
		return (value >>> 0).toString (16).toUpperCase ();
		
	}
	
	
	it ("fromBase64", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromBase64;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("fromBytes", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromBytes;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("fromCanvas", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromCanvas;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("fromFile", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromFile;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("fromImage", function () {
		
		// TODO: Confirm functionality
		
		var exists = BitmapData.fromImage;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("height", function () {
		
		var bitmapData = new BitmapData (1, 1);
		
		assert.equal (bitmapData.height, 1);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		assert.equal (bitmapData.height, 100);
		
	});
	
	
	it ("image", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.image;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("rect", function () {
		
		var bitmapData = new BitmapData (1, 1);
		
		assert.equal (bitmapData.rect.x, 0);
		assert.equal (bitmapData.rect.y, 0);
		assert.equal (bitmapData.rect.width, 1);
		assert.equal (bitmapData.rect.height, 1);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		assert.equal (bitmapData.rect.x, 0);
		assert.equal (bitmapData.rect.y, 0);
		assert.equal (bitmapData.rect.width, 100);
		assert.equal (bitmapData.rect.height, 100);
		
	});
	
	
	it ("transparent", function () {
		
		var bitmapData = new BitmapData (100, 100);
		
		assert (bitmapData.transparent);
		assert.equal (hex (bitmapData.getPixel (0, 0)), hex (0xFFFFFF));
		assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0xFF);
		
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0);
		
		bitmapData = new BitmapData (100, 100, false);
		
		assert.equal (bitmapData.transparent, false);
		assert.equal (hex (bitmapData.getPixel (0, 0)), hex (0xFFFFFF));
		assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0xFF);
		
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0xFF);
		
		bitmapData = new BitmapData (100, 100, true);
		bitmapData.setPixel32 (0, 0, 0x00FFFFFF);
		
		var pixels = bitmapData.getPixels (bitmapData.rect);
		pixels.position = 0;
		
		bitmapData = new BitmapData (100, 100, false);
		bitmapData.setPixels (bitmapData.rect, pixels);
		
		assert.equal (bitmapData.getPixel32 (0, 0) >> 24 & 0xFF, 0xFF);
		
	});
	
	
	it ("width", function () {
		
		var bitmapData = new BitmapData (1, 1);
		
		assert.equal (bitmapData.width, 1);
		
		bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		assert.equal (bitmapData.width, 100);
		
	});
	
	
	it ("new", function () {
		
		var bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		bitmapData = new BitmapData (100, 100);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFFFFFF));
		
	});
	
	
	// it ("applyFilter", function () {
		
	// 	var filter = new GlowFilter (0xFFFF0000, 1, 10, 10, 100);
		
	// 	var bitmapData = new BitmapData (100, 100, true, 0xFFFF0000);
	// 	var bitmapData2 = new BitmapData (100, 100);
	// 	bitmapData2.applyFilter (bitmapData, bitmapData.rect, new Point (), filter);
		
	// 	assert.equal (hex (bitmapData2.getPixel32 (1, 1)), hex (0xFFFF0000));
		
	// 	var filterRect = bitmapData2.generateFilterRect (bitmapData2.rect, filter);
		
	// 	assert (filterRect.width > 100 && filterRect.width <= 115);
	// 	assert (filterRect.height > 100 && filterRect.height <= 115);
		
	// });
	
	
	it ("clone", function () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = bitmapData.clone();
		
		assert.notEqual (bitmapData, bitmapData2);
		assert.equal (bitmapData.width, bitmapData2.width);
		assert.equal (bitmapData.height, bitmapData2.height);
		assert.equal (bitmapData.transparent, bitmapData2.transparent);
		assert.equal (bitmapData.getPixel32 (0, 0), bitmapData2.getPixel32 (0, 0));
		
		var bitmapData = new BitmapData (100, 100, false, 0x00FF0000);
		var bitmapData2 = bitmapData.clone();
		
		assert.notEqual (bitmapData, bitmapData2);
		assert.equal (bitmapData.width, bitmapData2.width);
		assert.equal (bitmapData.height, bitmapData2.height);
		assert.equal (bitmapData.transparent, bitmapData2.transparent);
		assert.equal (bitmapData.getPixel32 (0, 0), bitmapData2.getPixel32 (0, 0));
		
	});
	
	
	it ("colorTransform", function () {
		
		var colorTransform = new ColorTransform (0, 0, 0, 1, 0xFF, 0, 0, 0);
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.colorTransform (new Rectangle (0, 0, 50, 50), colorTransform);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		assert.equal (hex (bitmapData.getPixel32 (50, 50)), hex (0xFFFFFFFF));
		
		bitmapData = new BitmapData (100, 100);
		bitmapData.colorTransform (bitmapData.rect, colorTransform);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		assert.equal (hex (bitmapData.getPixel32 (50, 50)), hex (0xFFFF0000));
		
	});
	
	
	it ("compare", function () {
		
		var bitmapData = new BitmapData (50, 50, true, 0xFFFF8800);
		var bitmapData2 = new BitmapData (50, 50, true, 0xFFCC6600);
		//var bitmapData2 = new BitmapData (50, 50, true, 0xCCCC6600);
		var bitmapData3:BitmapData = bitmapData.compare (bitmapData2) as BitmapData;
		
		//assert.areEqual (hex (0xFF8800), hex (bitmapData.getPixel (0, 0)));
		//assert.areEqual (hex (0xFFFF8800), hex (bitmapData.getPixel32 (0, 0)));
		//assert.areEqual (hex (0xCC6600), hex (bitmapData.getPixel (0, 0)));
		//assert.areEqual (hex (0xCCCC6600), hex (bitmapData.getPixel32 (0, 0)));
		
		assert.equal (hex (bitmapData3.getPixel (0, 0)), hex (0x332200));
		
		bitmapData = new BitmapData (50, 50, true, 0xFFFFAA00);
		bitmapData2 = new BitmapData (50, 50, true, 0xCCFFAA00);
		bitmapData3 = bitmapData.compare (bitmapData2) as BitmapData;
		
		assert.equal (hex (bitmapData3.getPixel32 (0, 0)), hex (0x33FFFFFF));
		
		bitmapData = new BitmapData (50, 50, false, 0xFFFF0000);
		bitmapData2 = new BitmapData (50, 50, false, 0xFFFF0000);
		
		assert.equal (bitmapData.compare (bitmapData), 0);
		assert.equal (bitmapData.compare (bitmapData2), 0);
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (60, 50);
		
		assert.equal (bitmapData.compare (bitmapData2), -3);
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (60, 60);
		
		assert.equal (bitmapData.compare (bitmapData2), -3);
		
		bitmapData = new BitmapData (50, 50);
		bitmapData2 = new BitmapData (50, 60);
		
		assert.equal (bitmapData.compare (bitmapData2), -4);
		
	});
	
	
	it ("copyChannel", function () {
		
		var bitmapData = new BitmapData (100, 100, true, 0xFF000000);
		var bitmapData2 = new BitmapData (100, 100, true, 0xFFFF0000);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFF000000));
		assert.equal (hex (bitmapData2.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.RED, BitmapDataChannel.RED);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		var bitmapData = new BitmapData (100, 100, false);
		var bitmapData2 = new BitmapData (100, 100, true, 0x00FF0000);
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFFFFFF));
		
		var bitmapData = new BitmapData (100, 100, true);
		var bitmapData2 = new BitmapData (100, 100, true, 0x22FF0000);
		
		bitmapData.copyChannel (bitmapData2, bitmapData2.rect, new Point (), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		
		//#if (!flash && !disable_cffi)
		//if (bitmapData.image.premultiplied) {
			//
			//assert.areEqual (hex (0x22F7F7F7), hex (bitmapData.getPixel32 (0, 0)));
			//
		//} else
		//#end
		{
			
			assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0x22FFFFFF));
			
		}
		
		var bitmapData = new BitmapData (100, 80, false, 0x00FF0000);
		
		bitmapData.copyChannel (bitmapData, new Rectangle (0, 0, 20, 20), new Point (10, 10), BitmapDataChannel.RED, BitmapDataChannel.BLUE);
		
		assert.equal (hex (bitmapData.getPixel32 (10, 10)), hex (0xFFFF00FF));
		assert.equal (hex (bitmapData.getPixel32 (30, 30)), hex (0xFFFF0000));
		
	});
	
	
	it ("copyPixels", function () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = new BitmapData (100, 100, true, 0xFFFF0000);
		
		bitmapData.copyPixels (bitmapData2, bitmapData2.rect, new Point ());
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		var bitmapData = new BitmapData (40, 40, false, 0x000000FF);
		var bitmapData2 = new BitmapData (80, 40, false, 0x0000CC44);
		
		bitmapData2.copyPixels (bitmapData, new Rectangle (0, 0, 20, 20), new Point (10, 10));
		
		assert.equal (hex (bitmapData2.getPixel32 (0, 0)), hex (0xFF00CC44));
		assert.equal (hex (bitmapData2.getPixel32 (10, 10)), hex (0xFF0000FF));
		assert.equal (hex (bitmapData2.getPixel32 (30, 30)), hex (0xFF00CC44));
		
	});
	
	
	it ("copyPixels", function () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = new BitmapData (100, 100, true, 0xFFFF0000);
		
		bitmapData.copyPixels (bitmapData2, bitmapData2.rect, new Point ());
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFF0000));
		
		var bitmapData = new BitmapData (40, 40, false, 0x000000FF);
		var bitmapData2 = new BitmapData (80, 40, false, 0x0000CC44);
		
		bitmapData2.copyPixels (bitmapData, new Rectangle (0, 0, 20, 20), new Point (10, 10));
		
		assert.equal (hex (bitmapData2.getPixel32 (0, 0)), hex (0xFF00CC44));
		assert.equal (hex (bitmapData2.getPixel32 (10, 10)), hex (0xFF0000FF));
		assert.equal (hex (bitmapData2.getPixel32 (30, 30)), hex (0xFF00CC44));
		
	});
	
	
	it ("dispose", function () {
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.dispose ();
		
		assert.equal (bitmapData.width, 0);
		assert.equal (bitmapData.height, 0);
		
	});
	
	
	it ("draw", function () {
		
		var bitmapData = new BitmapData (100, 100);
		var bitmapData2 = new Bitmap (new BitmapData (100, 100, true, 0xFF0000FF));
		
		bitmapData.draw (bitmapData2);
		
		//assert.areEqual (hex (0xFF0000FF), hex (bitmapData.getPixel32 (0, 0)));
		
		var sprite = new Sprite ();
		sprite.graphics.beginFill (0xFFFF0000);
		sprite.graphics.drawRect (0, 0, 100, 100);
		
		bitmapData.draw (sprite);
		
		//assert.areEqual (hex (0xFFFF0000), hex (bitmapData.getPixel32 (0, 0)));
		
		var sprite2 = new Sprite ();
		sprite2.graphics.beginFill (0x00FF00);
		sprite2.graphics.drawRect (0, 0, 100, 100);
		
		sprite.x = 50;
		sprite.y = 50;
		sprite2.addChild (sprite);
		
		bitmapData.draw (sprite2);
		
		//TODO: Look into software renderer to find why alpha is off by one
		assert (hex (bitmapData.getPixel32 (50, 50)) == hex (0xFFFF0000) || hex (bitmapData.getPixel32 (50, 50)) == hex (0xFEFF0000));
		
	});
	
	
	it ("drawWithQuality", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.drawWithQuality;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("encode", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.encode;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("fillRect", function () {
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.fillRect (bitmapData.rect, 0xFFCC8833);
		
		var pixel = bitmapData.getPixel32 (1, 1);
		assert.equal (hex (pixel), hex (0xFFCC8833));
		
		var bitmapData = new BitmapData (100, 100);
		bitmapData.fillRect (new Rectangle (99, 99), 0xFFCC8833);
		
		var pixel = bitmapData.getPixel32 (99, 99);
		assert.equal (hex (pixel), hex (0xFFFFFFFF));
		
		var bitmapData = new BitmapData (100, 100, false);
		bitmapData.fillRect (bitmapData.rect, 0x00CC8833);
		
		var pixel = bitmapData.getPixel32 (0, 0);
		assert.equal (hex (pixel), hex (0xFFCC8833));
		
	});
	
	
	it ("floodFill", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.floodFill;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("generateFilterRect", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.generateFilterRect;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getColorBoundsRect", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getColorBoundsRect;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getPixel", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getPixel;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getPixel32", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getPixel32;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getPixels", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.getPixels;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getVector", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.getVector;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("histogram", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.histogram;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("hitTest", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.hitTest;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("lock", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.lock;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("merge", function () {
		
		var color = 0xFF000000;
		var color2 = 0xFFFF0000;
		
		var bitmapData = new BitmapData (100, 100, true, color);
		var sourceBitmapData = new BitmapData (100, 100, true, color2);
		
		bitmapData.merge (sourceBitmapData, sourceBitmapData.rect, new Point (), 256, 256, 256, 256);
		
		var pixel = bitmapData.getPixel32 (1, 1);
		assert.equal (hex (pixel), hex (0xFFFF0000));
		
	});
	
	
	it ("noise", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.noise;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("paletteMap", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (1, 1);
		var exists = bitmapData.paletteMap;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("perlinNoise", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.perlinNoise;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("scroll", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.scroll;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setPixel", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixel;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setPixel32", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixel32;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setPixels", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setPixels;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setVector", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.setVector;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("threshold", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.threshold;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("unlock", function () {
		
		// TODO: Confirm functionality
		
		var bitmapData = new BitmapData (100, 100);
		var exists = bitmapData.unlock;
		
		assert.notEqual (exists, null);
		
	});
	
	
	var TEST_WIDTH : number = 100;
	var TEST_HEIGHT : number = 100;
	
	var testGetSetPixels = function (color : number, sourceAlpha: boolean, destAlpha: boolean) {
		var bitmapData = new BitmapData (TEST_WIDTH, TEST_HEIGHT, sourceAlpha, color);
		var pixels = bitmapData.getPixels (bitmapData.rect);
		
		assert.equal (pixels.length, TEST_WIDTH * TEST_HEIGHT * 4);
		
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
		
		var i : number;
		var pixel : number;
		pixels.position = 0;
		
		for (i = 0; i < TEST_WIDTH * TEST_HEIGHT; i++) {
			pixel = pixels.readInt();
			assert (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
			assert (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
			assert (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
			assert (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
		}
		
		// Now run the same test again to make sure the source
		// did not get changed by reading the first time.
		pixels = bitmapData.getPixels (bitmapData.rect);
		
		assert.equal (pixels.length, TEST_WIDTH * TEST_HEIGHT * 4);
		
		pixels.position = 0;
		for (i = 0; i < TEST_WIDTH * TEST_HEIGHT; i++) {
			pixel = pixels.readInt();
			assert (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
			assert (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
			assert (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
			assert (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
		}
		
		bitmapData = new BitmapData (TEST_WIDTH, TEST_HEIGHT, destAlpha);
		
		pixels.position = 0;
		bitmapData.setPixels (bitmapData.rect, pixels);
		
		var pixel:number = bitmapData.getPixel32 (1, 1);
		
		if (!destAlpha) {
			expectedColor |= 0xFF000000;
		}
		
		assert (Math.abs (((expectedColor >> 24) & 0xFF) - ((pixel >> 24) & 0xFF)) <= 1);
		assert (Math.abs (((expectedColor >> 16) & 0xFF) - ((pixel >> 16) & 0xFF)) <= 1);
		assert (Math.abs (((expectedColor >> 8) & 0xFF) - ((pixel >> 8) & 0xFF)) <= 1);
		assert (Math.abs (((expectedColor) & 0xFF) - ((pixel) & 0xFF)) <= 1);
	}
	
	// There are 6 combinations with an ARGB source that all must be tested:
	//	Fill color: Fully transparent, semi-transparent, fully opaque
	//   Dest bitmap: ARGB or RGB
	// Test each of these using a different test function so we
	// can easily tell which ones fails.
	it ("testGetAndSetPixelsTransparentARGBToARGB", function () {
		testGetSetPixels(0x00112233, true, true);
	});
	
	it ("testGetAndSetPixelsSemiARGBToARGB", function () {
		// TODO: Native targets do not match the flash behavior here.
		//	   If the native target is changed to match flash, 
		//	   testGetSetPixels() must be changed to match.
		testGetSetPixels(0x80112233, true, true);
	});
	
	it ("testGetAndSetPixelsOpqaueARGBToARGB", function () {
		testGetSetPixels(0xFF112233, true, true);
	});
	
	it ("testGetAndSetPixelsTransparentARGBToRGB", function () {
		testGetSetPixels(0x00112233, true, false);
	});
	
	it ("testGetAndSetPixelsSemiARGBToRGB", function () {
		// TODO
		testGetSetPixels(0x80112233, true, false);
	});
	
	it ("testGetAndSetPixelsOpqaueARGBToRGB", function () {
		testGetSetPixels(0xFF112233, true, false);
	});
	
	// There are also 2 combinations with an RGB source that must be tested:
	//   Dest bitmap: ARGB or RGB
	it ("testGetAndSetPixelsRGBToARGB", function () {
		testGetSetPixels(0x112233, false, true);
	});
	
	it ("testGetAndSetPixelsRGBToRGB", function () {
		testGetSetPixels(0x112233, false, false);
	});
	
	
});