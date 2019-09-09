package test;

import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.utils.Assets;
import openfl.events.Event;
import openfl.filters.GlowFilter;
import openfl.filters.BitmapFilterQuality;

class BatcherTest extends FunctionalTest
{
	private var bitmaps:Array<Bitmap> = [];

	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		var bitmapData = Assets.getBitmapData("assets/openfl.png");
		for (i in 0...10)
		{
			bitmaps[i] = new Bitmap(bitmapData);
			bitmaps[i].x = 50 + i * (bitmapData.width + 50);
			bitmaps[i].y = 50;
			content.addChild(bitmaps[i]);
		}

		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.cacheAsBitmap = false;
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
		bitmaps = [];
	}

	private function update(e:Event):Void {}
}
