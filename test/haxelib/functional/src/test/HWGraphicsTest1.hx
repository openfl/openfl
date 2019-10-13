package test;

#if draft
import haxe.Timer;
import openfl.display.Graphics;
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

		var square = new HWGraphics();
		square.graphics.beginFill(0x24AFC4);
		square.graphics.drawRect(0, 0, 100, 100);
		square.x = 20;
		square.y = 20;
		content.addChild(square);

		var rectangle = new HWGraphics();
		rectangle.graphics.beginFill(0x24AFC4);
		rectangle.graphics.drawRect(0, 0, 120, 100);
		rectangle.x = 140;
		rectangle.y = 20;
		content.addChild(rectangle);

		var circle = new HWGraphics();
		circle.graphics.beginFill(0x24AFC4);
		circle.graphics.drawCircle(50, 50, 50);
		circle.x = 280;
		circle.y = 20;
		content.addChild(circle);

		var ellipse = new HWGraphics();
		ellipse.graphics.beginFill(0x24AFC4);
		ellipse.graphics.drawEllipse(0, 0, 120, 100);
		ellipse.x = 400;
		ellipse.y = 20;
		content.addChild(ellipse);

		var roundSquare = new HWGraphics();
		roundSquare.graphics.beginFill(0x24AFC4);
		roundSquare.graphics.drawRoundRect(0, 0, 100, 100, 40, 40);
		roundSquare.x = 540;
		roundSquare.y = 20;
		content.addChild(roundSquare);

		var roundRectangle = new HWGraphics();
		roundRectangle.graphics.beginFill(0x24AFC4);
		roundRectangle.graphics.drawRoundRect(0, 0, 120, 100, 40, 40);
		roundRectangle.x = 660;
		roundRectangle.y = 20;
		content.addChild(roundRectangle);

		var triangle = new HWGraphics();
		triangle.graphics.beginFill(0x24AFC4);
		triangle.graphics.moveTo(0, 100);
		triangle.graphics.lineTo(50, 0);
		triangle.graphics.lineTo(100, 100);
		triangle.graphics.lineTo(0, 100);
		triangle.x = 20;
		triangle.y = 150;
		content.addChild(triangle);

		var pentagon = new HWGraphics();
		pentagon.graphics.beginFill(0x24AFC4);
		drawPolygon(pentagon.graphics, 50, 50, 50, 5);
		pentagon.x = 145;
		pentagon.y = 150;
		content.addChild(pentagon);

		var hexagon = new HWGraphics();
		hexagon.graphics.beginFill(0x24AFC4);
		drawPolygon(hexagon.graphics, 50, 50, 50, 6);
		hexagon.x = 270;
		hexagon.y = 150;
		content.addChild(hexagon);

		var heptagon = new HWGraphics();
		heptagon.graphics.beginFill(0x24AFC4);
		drawPolygon(heptagon.graphics, 50, 50, 50, 7);
		heptagon.x = 395;
		heptagon.y = 150;
		content.addChild(heptagon);

		var octogon = new HWGraphics();
		octogon.graphics.beginFill(0x24AFC4);
		drawPolygon(octogon.graphics, 50, 50, 50, 8);
		octogon.x = 520;
		octogon.y = 150;
		content.addChild(octogon);

		var decagon = new HWGraphics();
		decagon.graphics.beginFill(0x24AFC4);
		drawPolygon(decagon.graphics, 50, 50, 50, 10);
		decagon.x = 650;
		decagon.y = 150;
		content.addChild(decagon);

		var line = new HWGraphics();
		line.graphics.lineStyle(10, 0x24AFC4);
		line.graphics.lineTo(755, 0);
		line.x = 20;
		line.y = 280;
		content.addChild(line);

		var curve = new HWGraphics();
		curve.graphics.lineStyle(10, 0x24AFC4);
		curve.graphics.curveTo(327.5, -50, 755, 0);
		curve.x = 20;
		curve.y = 340;
		content.addChild(curve);

		var shape = new HWGraphics();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 100, 100);
		shape.x = 100;
		shape.y = 100;

		content.addChild(shape);

		var shape = new HWGraphics();
		shape.graphics.beginFill(0x00FF00);
		shape.graphics.lineStyle(4, 0);
		shape.graphics.drawCircle(100, 100, 20);
		shape.x = 40;
		shape.y = 200;

		content.addChild(shape);
	}

	private function drawPolygon(graphics:Graphics, x:Float, y:Float, radius:Float, sides:Int):Void
	{
		var step = (Math.PI * 2) / sides;
		var start = 0.5 * Math.PI;

		graphics.moveTo(Math.cos(start) * radius + x, -Math.sin(start) * radius + y);

		for (i in 0...sides)
		{
			graphics.lineTo(Math.cos(start + (step * i)) * radius + x, -Math.sin(start + (step * i)) * radius + y);
		}
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
