package test;

import openfl.display.Bitmap;
import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.utils.Assets;

/**
 * Class: BlendModeTest1
 * Tests clipping using scroll rect
 */
class BlendModeTest1 extends FunctionalTest
{
	private static var blendModes = [
		BlendMode.NORMAL, BlendMode.LAYER, BlendMode.MULTIPLY, BlendMode.SCREEN, BlendMode.LIGHTEN, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ADD,
		BlendMode.SUBTRACT, BlendMode.INVERT, BlendMode.ALPHA, BlendMode.ERASE, BlendMode.OVERLAY, BlendMode.HARDLIGHT
	];

	public function new()
	{
		super();
	}

	private function createOverlay(x:Float, y:Float, blendMode:BlendMode):Void
	{
		var square = new Bitmap(Assets.getBitmapData("assets/BlendSquare.png"));
		square.x = x - (square.width / 2);
		square.y = y - (square.height / 2);
		content.addChild(square);

		var circle = new Bitmap(Assets.getBitmapData("assets/BlendCircle.png"));
		circle.x = x - 10;
		circle.y = y - 10;
		circle.blendMode = blendMode;
		content.addChild(circle);

		var text = new TextField();
		var textFormat = new TextFormat("_sans", 14, 0, true);
		textFormat.align = TextFormatAlign.CENTER;
		text.selectable = false;
		text.defaultTextFormat = textFormat;
		text.x = x - (square.height / 2) - 30;
		text.y = y + (square.height / 2) + 40;
		text.width = 200;
		text.height = 200;
		text.textColor = 0x222222;
		text.text = Std.string(blendMode);
		content.addChild(text);
	}

	public override function start():Void
	{
		content = new Sprite();
		content.graphics.beginFill(0xFFFFFF);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);

		// Compute the size of the grid needed to show all blend modes
		var rows = 1;
		var columns;

		// Assume a 16:9 aspect ratio of the window
		while (true)
		{
			if ((rows * ((rows * 16) / 9)) >= blendModes.length)
			{
				break;
			}
			rows += 1;
		}

		columns = Std.int((rows * 16) / 9);

		for (y in 0...rows)
		{
			for (x in 0...columns)
			{
				var index = (y * columns) + x;
				if (index >= blendModes.length)
				{
					continue;
				}
				var xpos = ((contentWidth * x) / columns) + (contentWidth / (2 * columns));
				var ypos = (((contentHeight * y) / rows) + (contentHeight / (2 * rows))) - 20;
				createOverlay(xpos, ypos, blendModes[index]);
			}
		}
	}

	public override function stop():Void
	{
		content = null;
	}
}
