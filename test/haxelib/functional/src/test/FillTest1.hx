package test;

import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * Class: FillTest1
 *
 * Draws a random filled rectangle to the screen.
 */
class FillTest1 extends FunctionalTest
{
	public static var rectangle:Sprite;

	public function new()
	{
		super();
	}

	private function pos(i:Int):Float
	{
		return (i * contentHeight) / 720;
	}

	public override function start():Void
	{
		content = new Sprite();

		// These numbers all come from the reference image and need to be
		// exactly this unless the reference image changes.

		// Black background
		content.graphics.beginFill(0);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);

		// Red square
		content.graphics.beginFill(0xFF0000);
		content.graphics.drawRect(pos(148), pos(67), pos(370), pos(273));

		// Blue square
		content.graphics.beginFill(0x0000FF);
		content.graphics.drawRect(pos(281), pos(201), pos(501), pos(447));

		// Green square
		content.graphics.beginFill(0x00FF00);
		content.graphics.drawRect(pos(420), pos(224), pos(182), pos(97));

		rectangle = new Sprite();
		content.addChild(rectangle);

		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
	}

	private function update(e:Event):Void
	{
		// Black background
		content.graphics.clear();
		content.graphics.beginFill(0);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);

		var width:Int = SeededRandom.random(1279);
		var height:Int = SeededRandom.random(719);
		var x:Int = SeededRandom.random(1280 - width);
		var y:Int = SeededRandom.random(720 - height);
		var color:Int = SeededRandom.random(0x1000000);

		// Draw a rectangle of a random size and color
		rectangle.graphics.clear();
		rectangle.graphics.beginFill(color);
		rectangle.graphics.drawRect(pos(x), pos(y), pos(width), pos(height));
	}
}
