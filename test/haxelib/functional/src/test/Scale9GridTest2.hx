package test;

import openfl.text.TextField;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.utils.Assets;

class Scale9GridTest2 extends FunctionalTest
{
	private var rpatt:BitmapData;

	public function new()
	{
		super();
	}

	private function createDummyBox(border:Int, rwidth:Int, cutgrid:Rectangle):Sprite
	{
		var dummy = new Sprite();

		var matrix = new openfl.geom.Matrix();
		matrix.scale(0.1, 0.1);

		var g = dummy.graphics;
		// g.beginFill(0xFF,0.5);
		g.beginBitmapFill(this.rpatt, matrix, true, true);
		g.lineStyle(border, 0);
		g.drawRoundRect(0, 0, rwidth, rwidth, 10, 10);
		g.endFill();

		g.lineStyle(1, 0, 1);

		g.drawRect(cutgrid.x, cutgrid.y, cutgrid.width, cutgrid.height);

		trace(cutgrid);
		dummy.scale9Grid = cutgrid;

		return dummy;
	}

	public override function start():Void
	{
		content = new Sprite();
		content.x = 40;
		content.y = -40;

		var rwidth = 70;

		// Background vector created by davidzydd - www.freepik.com
		this.rpatt = Assets.getBitmapData("assets/repeat-texture.jpg");

		for (i in 1...8)
		{
			var border = i * 2;
			var dbox = createDummyBox(2, rwidth, new Rectangle(border, border, rwidth - (border * 2), rwidth - (border * 2)));

			content.addChild(dbox);
			dbox.y = (i * rwidth) + (i * 5);
			dbox.width = 300;
		}
	}

	public override function stop():Void
	{
		content = null;
	}
}
