package test;

import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.utils.Assets;

/**
 * Class: ClipTest1
 *
 * Tests clipping using scroll rect
 * Here it renders a specific image to the screen.
 */
class ClipTest1 extends FunctionalTest
{
	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		// Set stage background
		content.graphics.beginFill(0xFFFFFF);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);

		// Background images - two rows of 4
		var image = Assets.getBitmapData("assets/openfl.png");

		for (i in 0...8)
		{
			var bitmap = new Bitmap(image);
			// x, y to center point
			bitmap.x = ((i % 4) * (contentWidth / 4)) + (contentWidth / 8);

			if (i < 4)
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
			bitmap.alpha = 0.3;
			content.addChild(bitmap);
		}

		// Top row: images
		var bitmaps = new Array<Bitmap>();

		for (i in 0...4)
		{
			var bitmap = new Bitmap(image);
			// x, y to center point
			bitmap.x = ((i % 4) * (contentWidth / 4)) + (contentWidth / 8);

			if (i < 4)
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
			content.addChild(bitmap);
			bitmaps.push(bitmap);
		}

		// First: no scroll rect
		// No scroll rect to set ...

		// Second: scroll rect that just clips
		bitmaps[1].scrollRect = new Rectangle(0, 0, image.width / 2, image.height / 2);

		// Third: scroll rect that clips and translates
		bitmaps[2].scrollRect = new Rectangle(image.width / 2, image.height / 2, image.width / 2, image.height / 2);

		// Fourth: scroll rect that scrolls it entirely away
		bitmaps[3].scrollRect = new Rectangle(contentWidth * 2, contentHeight * 2, contentWidth * 10, contentHeight * 10);

		// Bottom row: text
		var textFormat = new TextFormat("_sans", 32, 0, false);
		textFormat.align = TextFormatAlign.CENTER;
		var textFields = new Array<TextField>();

		for (i in 0...4)
		{
			var textField = new TextField();
			textField.selectable = false;
			textField.defaultTextFormat = textFormat;
			textField.x = (i % 4) * (contentWidth / 4);
			textField.y = (contentHeight / 2) + (contentHeight / 4);
			textField.width = 400;
			textField.height = 400;
			content.addChild(textField);
			textFields.push(textField);
		}

		// First: no scroll rect
		textFields[0].textColor = 0xAA1100;
		textFields[0].text = "Text Field 1";

		// Second: scroll rect that just clips
		textFields[1].scrollRect = new Rectangle(0, 0, 200, 200);
		textFields[1].textColor = 0x11AA00;
		textFields[1].text = "Text Field 2";

		// Third: scroll rect that clips and translates
		textFields[2].scrollRect = new Rectangle(0, 40, 200, 20);
		textFields[2].textColor = 0x1100AA;
		textFields[2].text = "Text Field 3";

		// Fourth: scroll rect that scrolls it entirely away
		textFields[3].scrollRect = new Rectangle(contentWidth * 2, contentHeight * 2, contentWidth * 10, contentHeight * 10);
		textFields[3].textColor = 0x660066;
		textFields[3].text = "Text Field 4";
	}

	public override function stop():Void
	{
		content = null;
	}
}
