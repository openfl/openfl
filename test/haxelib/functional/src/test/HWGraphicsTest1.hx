package test;

#if draft
import haxe.Timer;
import openfl.display.HWGraphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.utils.Assets;

class HWGraphicsTest1 extends FunctionalTest
{
	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();
		content.addEventListener(Event.ENTER_FRAME, update);

		var shape = new HWGraphics();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 100, 100);
		shape.x = 100;
		shape.y = 100;
		shape.graphics.beginFill(0x00FF00);
		shape.graphics.lineStyle(4, 0);
		shape.graphics.drawCircle(100, 100, 20);

		content.addChild(shape);
	}

	public override function stop():Void
	{
		content.cacheAsBitmap = false;
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
	}

	private function update(e:Event):Void
	{
		var sinT = Math.sin(Timer.stamp()) * 0.5 + 0.5;
		content.alpha = sinT;
	}
}
#end
