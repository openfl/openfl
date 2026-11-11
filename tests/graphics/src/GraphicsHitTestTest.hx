package;

import openfl.display.Graphics;
import openfl.display.Sprite;
import utest.Assert;
import utest.Test;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display._internal.CairoGraphics)
class GraphicsHitTestTest extends Test
{
	public function test_adjacentRectangles()
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(0, 0, 100, 50);
		sprite.graphics.drawRect(0, 50, 100, 50);
		sprite.graphics.endFill();

		#if !flash
		Assert.equals(1, sprite.graphics.__hitTestFilledRects(50, 25));
		#end
		Assert.isTrue(hitTest(sprite, 50, 25));
		Assert.isTrue(hitTest(sprite, 50, 75));
		// On the edge the two share
		Assert.isTrue(hitTest(sprite, 50, 50));
		Assert.isFalse(hitTest(sprite, 150, 25));
	}

	public function test_rectangleOverAnotherInOneFill()
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(0, 0, 100, 100);
		sprite.graphics.drawRect(25, 25, 50, 50);
		sprite.graphics.endFill();

		Assert.isTrue(hitTest(sprite, 10, 10));
		Assert.isFalse(hitTest(sprite, 50, 50));
		Assert.isTrue(hitTest(sprite, 25, 50));
	}

	public function test_rectangleOverAnotherInTwoFills()
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(0, 0, 100, 100);
		sprite.graphics.endFill();
		sprite.graphics.beginFill(0x00FF00);
		sprite.graphics.drawRect(25, 25, 50, 50);
		sprite.graphics.endFill();

		Assert.isTrue(hitTest(sprite, 10, 10));
		Assert.isTrue(hitTest(sprite, 50, 50));
	}

	public function test_rectangleWithoutFill()
	{
		var sprite = new Sprite();
		sprite.graphics.drawRect(0, 0, 50, 50);
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(100, 0, 50, 50);
		sprite.graphics.endFill();
		sprite.graphics.drawRect(200, 0, 50, 50);

		#if !flash
		Assert.equals(0, sprite.graphics.__hitTestFilledRects(25, 25));
		#end
		Assert.isFalse(hitTest(sprite, 25, 25));
		Assert.isTrue(hitTest(sprite, 125, 25));
		Assert.isFalse(hitTest(sprite, 225, 25));
	}

	public function test_changedGraphics()
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(0, 0, 50, 50);

		Assert.isTrue(hitTest(sprite, 25, 25));
		Assert.isFalse(hitTest(sprite, 125, 25));

		sprite.graphics.drawRect(100, 0, 50, 50);

		Assert.isTrue(hitTest(sprite, 125, 25));

		sprite.graphics.clear();
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(100, 0, 50, 50);

		Assert.isFalse(hitTest(sprite, 25, 25));
		Assert.isTrue(hitTest(sprite, 125, 25));
	}

	public function test_otherGraphicsAreReplayed()
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.drawRect(0, 0, 100, 100);
		sprite.graphics.moveTo(200, 0);
		sprite.graphics.lineTo(300, 0);
		sprite.graphics.lineTo(200, 100);
		sprite.graphics.endFill();

		#if !flash
		Assert.equals(-1, sprite.graphics.__hitTestFilledRects(50, 50));
		#end
		Assert.isTrue(hitTest(sprite, 50, 50));
		Assert.isTrue(hitTest(sprite, 220, 20));
		Assert.isFalse(hitTest(sprite, 290, 90));

		var stroked = new Sprite();
		stroked.graphics.lineStyle(10, 0);
		stroked.graphics.beginFill(0xFF0000);
		stroked.graphics.drawRect(0, 0, 100, 100);

		#if !flash
		Assert.equals(-1, stroked.graphics.__hitTestFilledRects(50, 50));
		#end

		var scaled = new Sprite();
		scaled.graphics.beginFill(0xFF0000);
		scaled.graphics.drawRect(0, 0, 100, 100);
		scaled.scale9Grid = new openfl.geom.Rectangle(10, 10, 80, 80);

		#if !flash
		Assert.equals(-1, scaled.graphics.__hitTestFilledRects(50, 50));
		#end
	}

	// What hitTestPoint(x, y, true) does for a sprite on the stage
	private function hitTest(sprite:Sprite, x:Float, y:Float):Bool
	{
		#if flash
		return sprite.hitTestPoint(x, y, true);
		#else
		return sprite.__hitTest(x, y, true, null, false, sprite);
		#end
	}

	#if (lime_cffi && !html5 && !flash)
	public function test_sameAnswersAsReplayingTheCommands()
	{
		var sprite = new Sprite();
		var graphics = sprite.graphics;
		graphics.beginFill(0xFF0000);
		graphics.drawRect(0.3, 0.7, 20.4, 10.1);
		graphics.drawRect(0.3, 10.8, 20.4, 5.25);
		graphics.drawRect(5.5, 2.5, 30, 6);
		graphics.drawRect(40, 12, -8, -6);
		graphics.endFill();
		graphics.beginFill(0x00FF00);
		graphics.drawRect(15, 4, 10, 20);
		graphics.drawRect(-6.125, -3, 4, 4);
		graphics.drawRect(50, 0, 0, 10);
		graphics.endFill();
		graphics.drawRect(44, 20, 6, 6);

		Assert.notEquals(-1, graphics.__hitTestFilledRects(1, 1));

		// Around each edge, down to less than Cairo's grid of 1/256
		var offsets = [-0.5, -1 / 256, -1 / 512, 0, 1 / 512, 1 / 256, 0.5];
		var xs = [];
		var ys = [];

		for (offset in offsets)
		{
			for (edge in [0.3, 20.7, 5.5, 35.5, 40, 32, 15, 25, -6.125, -2.125, 50])
				xs.push(edge + offset);
			for (edge in [0.7, 10.8, 16.05, 2.5, 8.5, 12, 6, 4, 24, -3, 1, 0, 10])
				ys.push(edge + offset);
		}

		var differences = 0;
		var hits = 0;

		for (y in ys)
		{
			for (x in xs)
			{
				// As Graphics.__hitTest does before either
				if (x > graphics.__bounds.x && y > graphics.__bounds.y && graphics.__bounds.contains(x, y))
				{
					var replayed = openfl.display._internal.CairoGraphics.hitTest(graphics, x, y);
					if (replayed) hits++;
					if (replayed != (graphics.__hitTestFilledRects(x, y) == 1)) differences++;
				}
			}
		}

		Assert.equals(0, differences);
		Assert.isTrue(hits > 500);
	}
	#end
}
