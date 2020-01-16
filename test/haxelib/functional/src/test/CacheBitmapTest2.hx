package test;

import haxe.Timer;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * Class: CacheBitmapTest2
 *
 * This test builds off test #1. Two objects similar to the object under test in
 * test 1 are added as children of a parent, which also draws some of its own
 * rects. Then as the parent is moved around the screen, the cacheAsBitmap flag
 * is toggled on each of these three objects.
 */
class CacheBitmapTest2 extends FunctionalTest
{
	private static var COLORS = [
		0xFF3366FF, 0xFF6633FF, 0xFFCC33FF, 0xFFFF33CC, 0xFF33CCFF, 0xFF003DF5, 0xFF002EB8, 0xFFFF3366, 0xFF33FFCC, 0xFFB88A00, 0xFFF5B800, 0xFFFF6633,
		0xFF33FF66, 0xFF66FF33, 0xFFCCFF33, 0xFFFFCC33
	];
	private static var CENTER_X = 320;
	private static var CENTER_Y = 120;
	private static var CHANGE_INTERVAL = 3; // in seconds
	private static var NUM_RECTS = 4;
	private static var RADIUS = 120;
	private static var RPM = 20;

	private var angle:Float; // in radians
	private var cache:Int;
	private var child1:Sprite;
	private var child2:Sprite;
	private var frameCount:Int;
	private var lastTime:Float;
	private var parent:Sprite;
	private var switchTime:Float;
	private var text:TextField;
	private var totalTime:Float;

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

		angle = 0;
		// Start with cache = 1 so that the first frame, which is
		// used as the comparison test, is rendered with cacheAsBitmap
		// turned ON for the parent.
		cache = 1;
		frameCount = 0;
		totalTime = 0;

		lastTime = Timer.stamp();
		switchTime = lastTime + CHANGE_INTERVAL;

		// Stage background
		content.graphics.beginFill(0);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);

		var newRect:Sprite;

		// Setup child 1
		child1 = new Sprite();
		child1.graphics.beginFill(0xFFFF0000);
		child1.graphics.drawRect(pos(75), pos(25), pos(125), pos(125));

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[0]);
		newRect.graphics.drawRect(0, 0, pos(100), pos(100));
		child1.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[1]);
		newRect.graphics.drawRect(pos(125), pos(10), pos(100), pos(100));
		child1.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[2]);
		newRect.graphics.drawRect(pos(125), pos(110), pos(100), pos(100));
		child1.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[3]);
		newRect.graphics.drawRect(0, pos(110), pos(100), pos(100));
		child1.addChild(newRect);

		// Setup child 2
		child2 = new Sprite();
		child2.graphics.beginFill(0xFFFF0000);
		child2.graphics.drawRect(pos(415), pos(25), pos(125), pos(125));

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[4]);
		newRect.graphics.drawRect(pos(340), 0, pos(100), pos(100));
		child2.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[5]);
		newRect.graphics.drawRect(pos(465), pos(10), pos(100), pos(100));
		child2.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[6]);
		newRect.graphics.drawRect(pos(465), pos(110), pos(100), pos(100));
		child2.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[7]);
		newRect.graphics.drawRect(pos(340), pos(110), pos(100), pos(100));
		child2.addChild(newRect);

		// Setup parent
		parent = new Sprite();
		parent.graphics.beginFill(0xFFFF0000);
		parent.graphics.drawRect(0, 0, pos(640), pos(480));

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[8]);
		newRect.graphics.drawRect(pos(207), pos(300), pos(100), pos(100));
		parent.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[9]);
		newRect.graphics.drawRect(pos(332), pos(310), pos(100), pos(100));
		parent.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[10]);
		newRect.graphics.drawRect(pos(332), pos(410), pos(100), pos(100));
		parent.addChild(newRect);

		newRect = new Sprite();
		newRect.graphics.beginFill(COLORS[11]);
		newRect.graphics.drawRect(pos(207), pos(410), pos(100), pos(100));
		parent.addChild(newRect);

		child2.x = pos(150);

		parent.addChild(child1);
		parent.addChild(child2);
		content.addChild(parent);

		var normalTextFormat = new TextFormat("_sans", Std.int(pos(32)), 0, false);
		normalTextFormat.align = TextFormatAlign.LEFT;

		text = new TextField();
		text.selectable = false;
		text.defaultTextFormat = normalTextFormat;
		text.x = pos(10);
		text.y = pos(10);
		text.width = pos(1270);
		text.height = pos(40);
		text.textColor = 0xffffffff;
		updateText();
		content.addChild(text);

		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
	}

	private function update(e:Event):Void
	{
		var timeNow = Timer.stamp();
		var timeDiff = timeNow - lastTime;
		frameCount++;
		totalTime = totalTime + timeDiff;
		lastTime = timeNow;

		var secPerRev = 60.0 / RPM;
		var percent = timeDiff / secPerRev;
		var angleDiff = percent * 2 * Math.PI;

		angle = angle + angleDiff;

		var xOff = pos(RADIUS) * Math.cos(angle);
		var yOff = pos(RADIUS) * Math.sin(angle);

		parent.x = pos(CENTER_X) + xOff;
		parent.y = pos(CENTER_Y) + yOff;

		if (timeNow >= switchTime)
		{
			trace("Average FPS: " + frameCount / totalTime);
			totalTime = 0;
			frameCount = 0;

			cache = (cache + 1) % 8;

			trace("cache: " + cache);

			updateText();
			switchTime = timeNow + CHANGE_INTERVAL;
		}
	}

	private function updateText():Void
	{
		text.text = "cacheAsBitmap: Parent: ";

		if ((cache & 1) == 1)
		{
			parent.cacheAsBitmap = true;
			text.text += "ON";
		}
		else
		{
			parent.cacheAsBitmap = false;
			text.text += "OFF";
		}

		text.text += " Child1: ";
		if ((cache & 2) == 2)
		{
			child1.cacheAsBitmap = true;
			text.text += "ON";
		}
		else
		{
			child1.cacheAsBitmap = false;
			text.text += "OFF";
		}

		text.text += " Child2: ";
		if ((cache & 4) == 4)
		{
			child2.cacheAsBitmap = true;
			text.text += "ON";
		}
		else
		{
			child2.cacheAsBitmap = false;
			text.text += "OFF";
		}
	}
}
