package test;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.utils.Assets;

class MaskTest1 extends FunctionalTest
{
	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		var image = Assets.getBitmapData("assets/openfl.png");
		var bitmaps = new Array<Bitmap>();
		var masks = new Array<Bitmap>();
		var bgMasks = new Array<Bitmap>();

		for (i in 0...4)
		{
			// Render a very light version of the bitmap in the spot where
			// it would be if it were not masked
			var bgBitmap = new Bitmap(image.clone());
			content.addChild(bgBitmap);
			// Render a very light version of the bitmap in the spot where the
			// mask is
			var bgMask = new Bitmap(image.clone());
			content.addChild(bgMask);
			// Place the bitmap
			var bitmap = new Bitmap(image.clone());
			content.addChild(bitmap);
			// Use a mask
			var mask = new Bitmap(image.clone());
			content.addChild(mask);

			// x, y to center point
			bitmap.x = ((i % 2) * (contentWidth / 3)) + (contentWidth / 6);
			if (i < 2)
			{
				bitmap.y = 0;
			}
			else
			{
				bitmap.y = (contentHeight / 2);
			}
			// Center images
			bitmap.x -= image.width / 2;
			bitmap.y += image.height / 2;
			bgBitmap.alpha = 0.3;
			bgBitmap.x = bitmap.x;
			bgBitmap.y = bitmap.y;
			bitmaps.push(bitmap);
			mask.x = bitmap.x;
			mask.y = bitmap.y;
			masks.push(mask);
			bgMask.alpha = 0.3;
			bgMask.x = mask.x;
			bgMask.y = mask.y;
			bgMasks.push(bgMask);
			// Set the mask as the mask for the bitmap
			bitmap.mask = mask;
		}

		// Create two alpha masks
		var alphaMask1 = new BitmapData(image.width, image.height);
		for (y in 0...image.height)
		{
			var alpha = Std.int(((image.height - y) * 0xFF) / image.height);
			var color = alpha << 24;
			alphaMask1.fillRect(new Rectangle(0, y, image.width, 1), color);
		}

		var alphaMask2 = new BitmapData(image.width, image.height);
		var blockWidth = Std.int(image.width / 8);
		var blockHeight = Std.int(image.height / 8);

		for (y in 0...8)
		{
			var toggle = ((y % 2) == 0);
			for (x in 0...8)
			{
				alphaMask2.fillRect(new Rectangle(x * blockWidth, y * blockHeight, blockWidth, blockHeight), toggle ? 0x22000000 : 0xCC000000);
				toggle = !toggle;
			}
		}

		// Place the bitmap
		var bitmap = new Bitmap(image.clone());
		content.addChild(bitmap);
		// Use a mask
		var mask = new Bitmap(alphaMask1);
		bitmap.cacheAsBitmap = true;
		mask.cacheAsBitmap = true;
		content.addChild(mask);

		// x, y to center point
		bitmap.x = (2 * (contentWidth / 3)) + (contentWidth / 6);
		bitmap.y = 0;
		// Center images
		bitmap.x -= image.width / 2;
		bitmap.y += image.height / 2;
		bitmaps.push(bitmap);
		mask.x = bitmap.x;
		mask.y = bitmap.y;
		masks.push(mask);
		// Set the mask as the mask for the bitmap
		bitmap.mask = mask;

		bitmap = new Bitmap(image.clone());
		content.addChild(bitmap);
		// Use a mask
		mask = new Bitmap(alphaMask2);
		bitmap.cacheAsBitmap = true;
		mask.cacheAsBitmap = true;
		content.addChild(mask);

		// x, y to center point
		bitmap.x = (2 * (contentWidth / 3)) + (contentWidth / 6);
		bitmap.y = (contentHeight / 2);
		// Center images
		bitmap.x -= image.width / 2;
		bitmap.y += image.height / 2;
		bitmaps.push(bitmap);
		mask.x = bitmap.x;
		mask.y = bitmap.y;
		masks.push(mask);
		// Set the mask as the mask for the bitmap
		bitmap.mask = mask;

		// Leave the top left mask alone - so the mask should exactly match
		// the image and the image should look normal

		// Top right mask shift up and left a little.  Should cut out a bit
		// of the lower right of the image.
		masks[1].x -= 10;
		masks[1].y -= 10;
		bgMasks[1].x = masks[1].x;
		bgMasks[1].y = masks[1].y;

		// Bottom left mask down and right alot.  Should cut out most of the
		// upper left of the image.
		masks[2].x += image.width / 4;
		masks[2].y += image.height / 4;
		bgMasks[2].x = masks[2].x;
		bgMasks[2].y = masks[2].y;
		// Also, set it to not clear pixels that are outside of the bounds of
		// the mask, to test the special additional property
		// bitmaps[2].nonMaskedVisible = true;

		// Bottom right mask shift totally away.  Should totally cut out
		// the image.
		masks[3].x += contentWidth * 10;
		masks[3].y += contentHeight * 10;
		bgMasks[3].x = masks[3].x;
		bgMasks[3].y = masks[3].y;
	}

	public override function stop():Void
	{
		content = null;
	}
}
