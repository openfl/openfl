package test;

import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.utils.Assets;
import openfl.events.Event;
import openfl.filters.BlurFilter;

class BlurTest1 extends FunctionalTest
{
	private var bitmap:Bitmap;
	private var blurFilter:BlurFilter;

	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		bitmap = new Bitmap(Assets.getBitmapData("assets/OwlAlpha.png"));
		content.addChild(bitmap);

		blurFilter = new BlurFilter(1, 1, 16);
		bitmap.filters = [blurFilter];

		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
		bitmap = null;
		blurFilter = null;
	}

	private function update(e:Event):Void
	{
		var sinT = Math.sin(Timer.stamp() * 0.5);
		var amount = Math.abs(sinT) * 64;
		blurFilter.blurX = amount;
		blurFilter.blurY = amount;
		bitmap.filters = [blurFilter];
	}
}
