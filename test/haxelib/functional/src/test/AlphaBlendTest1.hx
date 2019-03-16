package test;

import openfl.display.Sprite;

/**
 * Class: AlphaBlendTest1
 *
 * Tests alpha blended fills and blits.  Splits the screen up into
 * three columns:
 * - First 1/4 of screen is expected color
 * - Second 1/4 of screen is alpha blended with no cache as bitmap
 * - Third 1/4 of screen is alpha blended with cache as bitmap
 * - Fourth 1/4 of screen is expected color using just alpha bits of color
 *
 * And many rows, where each row is a different level of alpha from
 * 1.0 down to 0.0 in decrements of 1/8.
 *
 * All rows should look the same all the way across.
 */
class AlphaBlendTest1 extends FunctionalTest
{
	public function new()
	{
		super();
	}

	private function createCell(color:Int, alpha:Float, x:Int, y:Int, cacheAsBitmap:Bool):Void
	{
		var sprite = new Sprite();
		sprite.cacheAsBitmap = cacheAsBitmap;
		sprite.graphics.beginFill(color, alpha);
		sprite.graphics.drawRect(0, 0, contentWidth / 4.0, contentHeight / 9.0);
		sprite.graphics.endFill();

		sprite.x = (x * (contentWidth / 4.0));
		sprite.y = (y * (contentHeight / 9.0));

		content.addChild(sprite);
	}

	public override function start():Void
	{
		content = new Sprite();

		for (y in 0...9)
		{
			var alpha = 1.0 - (y / 8.0);
			var frag = Std.int(alpha * 255);
			var color = (frag << 16) | (frag << 8) | frag;

			createCell(color, 1.0, 0, y, false);

			createCell(0xFFFFFF, 1.0, 1, y, false);
			createCell(0x000000, 1.0 - alpha, 1, y, false);

			createCell(0xFFFFFF, 1.0, 2, y, true);
			createCell(0x000000, 1.0 - alpha, 2, y, true);

			createCell(0xFFFFFF, 1.0, 3, y, false);
			createCell(frag << 24, 1.0, 3, y, false);
		}
	}

	public override function stop():Void
	{
		content = null;
	}
}
