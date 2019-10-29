package test;

#if draft
import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Geometry;
import openfl.utils.Assets;
import openfl.events.Event;
import openfl.filters.GlowFilter;
import openfl.filters.BitmapFilterQuality;

class GeometryTest extends FunctionalTest
{
	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();
		content.addEventListener(Event.ENTER_FRAME, update);

		var geom = new Geometry();
		geom.pushVertex(0, 0, 0xFF0000, 0.5);
		geom.pushVertex(100, 0, 0x00FF00, 1.0);
		geom.pushVertex(100, 100, 0x0000FF, 0.8);
		geom.x = 10;
		geom.y = 10;

		content.addChild(geom);
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
