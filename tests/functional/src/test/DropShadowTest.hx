package test;

import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.utils.Assets;
import openfl.events.Event;
import openfl.filters.DropShadowFilter;
import openfl.filters.GlowFilter;
import openfl.filters.BitmapFilter;
import openfl.filters.BitmapFilterQuality;

class DropShadowTest extends FunctionalTest
{
	private var bitmaps:Array<Bitmap> = [];
	private var filters:Array<DropShadowFilter> = [];

	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		var bitmapData = Assets.getBitmapData("assets/openfl.png");

		for (i in 0...6)
		{
			bitmaps[i] = new Bitmap(bitmapData);
			bitmaps[i].x = 50 + i * (bitmapData.width + 50);
			bitmaps[i].y = 50;
			filters[i] = new DropShadowFilter(4, 45, 0x000000, 1.0, 4, 4, 1, BitmapFilterQuality.HIGH, false, false, false);
			bitmaps[i].filters = [filters[i]];
			content.addChild(bitmaps[i]);
		}

		filters[1].inner = true;

		filters[2].knockout = true;

		filters[3].inner = true;
		filters[3].knockout = true;

		filters[4].hideObject = true;

		filters[5].inner = true;
		filters[5].hideObject = true;

		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
		bitmaps = [];
		filters = [];
	}

	private function update(e:Event):Void
	{
		var sinT = Math.sin(Timer.stamp()) * 0.5 + 0.5;
		var blur = 2 + sinT * 8;
		var angle = sinT * 360;
		for (i in 0...6)
		{
			filters[i].blurX = filters[i].blurY = blur;
			filters[i].angle = angle;
			bitmaps[i].filters = [filters[i]];
		}
	}
}
