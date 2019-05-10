package test;

import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.utils.Assets;
import openfl.events.Event;
import openfl.filters.GlowFilter;
import openfl.filters.BitmapFilterQuality;

class InnerGlowTest extends FunctionalTest
{
	private var bitmaps:Array<Bitmap> = [];
	private var filters:Array<GlowFilter> = [];

	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		// TODO: Need an asset with an inside?
		var bitmapData = Assets.getBitmapData("assets/OwlAlpha.png");
		for (i in 0...BitmapFilterQuality.HIGH)
		{
			bitmaps[i] = new Bitmap(bitmapData);
			bitmaps[i].x = 50 + i * (bitmapData.width + 50);
			bitmaps[i].y = 50;
			content.addChild(bitmaps[i]);
			filters[i] = new GlowFilter(0xFEAA99, 0.25, 4, 4, 32, i, true, false);
			// filters[i] = new BlurFilter(4, 4, i + 1);
			bitmaps[i].filters = [filters[i]];
		}
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
		var sinT = Math.sin(Timer.stamp() * 0.5);
		var amount = Math.abs(sinT) * 64;
		for (i in 0...BitmapFilterQuality.HIGH)
		{
			filters[i].blurX = filters[i].blurY = amount;
			bitmaps[i].filters = [filters[i]];
		}
	}
}
