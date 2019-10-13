package test;

#if draft
import haxe.Timer;
import openfl.display.GLGraphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.utils.Assets;

class GLGraphicsTest1 extends FunctionalTest
{
	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();
		content.addEventListener(Event.ENTER_FRAME, update);

		var graphics = new GLGraphics();
		graphics.graphics.beginFill(0xFF0000);
		graphics.graphics.drawRect(0, 0, 100, 100);
		graphics.x = 10;
		graphics.y = 10;

		content.addChild(graphics);
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
