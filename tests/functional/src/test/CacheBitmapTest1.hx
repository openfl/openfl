package test;

import haxe.Timer;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;

/**
 * Class: CacheBitmapTest1
 *
 * Creates an object of overlapping alpha blended filled rounded rectangles,
 * then moves it around the screen.  Toggles the cacheAsBitmap flag every 2
 * seconds.
 */
class CacheBitmapTest1 extends FunctionalTest
{
	private static var CENTER_X = 527;
	private static var CENTER_Y = 255;
	private static var CHANGE_INTERVAL = 2; // in seconds
	private static var COLORS = [0xFF4CF0, 0xFFF372, 0x85FF75, 0x59DDFF];
	private static var NUM_RECTS = 4;
	private static var RADIUS = 200;
	private static var RPM = 5;
	private static var angle:Float; // in radians
	private static var cache:Bool;
	private static var lastTime:Float;
	private static var rect:Sprite;
	private static var rotatingText:TextField;
	private static var switchSwitch:Bool;
	private static var switchTime:Float;
	private static var text:TextField;
	private static var textCycle = ["Hello, World!", "Hi", ""];
	private static var textIndex:Int;

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
		cache = true;

		lastTime = Timer.stamp();
		switchTime = lastTime + CHANGE_INTERVAL;
		switchSwitch = false;

		// Stage background
		content.graphics.beginFill(0);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);
		content.graphics.endFill();

		// Add in some filled rectangles for the cached display object
		// to move over top of
		content.graphics.beginFill(0x002288, 1.0);
		content.graphics.drawRect(pos(500), pos(200), pos(200), pos(200));
		content.graphics.endFill();
		content.graphics.beginFill(0x002288, 0.5);
		content.graphics.drawRect(pos(700), pos(200), pos(200), pos(200));
		content.graphics.endFill();
		content.graphics.beginFill(0x002288, 0.1);
		content.graphics.drawRect(pos(500), pos(400), pos(200), pos(200));
		content.graphics.endFill();
		content.graphics.beginFill(0x002288, 0.0);
		content.graphics.drawRect(pos(700), pos(400), pos(200), pos(200));
		content.graphics.endFill();

		// Test background
		rect = new Sprite();
		rect.graphics.beginFill(0xFFFF0000);
		// Rect sizes were chosen to create overlapping rects.
		rect.graphics.drawRect(pos(75), pos(25), pos(125), pos(125));

		var newRect:Sprite;

		newRect = new Sprite();
		newRect.alpha = 0.66;
		newRect.graphics.beginFill(COLORS[0]);
		newRect.graphics.drawRoundRect(0, 0, pos(100), pos(100), pos(100), pos(100));
		rect.addChild(newRect);

		newRect = new Sprite();
		newRect.alpha = 0.66;
		newRect.graphics.beginFill(COLORS[1]);
		newRect.graphics.drawRoundRect(pos(125), pos(10), pos(100), pos(100), pos(20), pos(40));
		rect.addChild(newRect);

		newRect = new Sprite();
		newRect.alpha = 0.66;
		newRect.graphics.beginFill(COLORS[2]);
		newRect.graphics.drawRoundRect(pos(125), pos(110), pos(100), pos(100), pos(40), pos(20));
		rect.addChild(newRect);

		newRect = new Sprite();
		newRect.alpha = 0.66;
		newRect.graphics.beginFill(COLORS[3]);
		newRect.graphics.drawRoundRect(0, pos(110), pos(100), pos(100), pos(40), pos(40));
		rect.addChild(newRect);

		var normalTextFormat = new TextFormat("_sans", Std.int(pos(32)), 0, false);
		normalTextFormat.align = TextFormatAlign.LEFT;

		rotatingText = new TextField();
		rotatingText.defaultTextFormat = normalTextFormat;
		rotatingText.textColor = 0xFFFFFFFF;
		rotatingText.x = -pos(100);
		rotatingText.y = -pos(75);
		// rotatingText.background = true;
		// rotatingText.backgroundColor = 0xFF223344;
		rotatingText.autoSize = TextFieldAutoSize.LEFT;
		textIndex = 0;
		rotatingText.text = textCycle[textIndex];
		rect.addChild(rotatingText);

		text = new TextField();
		text.selectable = false;
		text.defaultTextFormat = normalTextFormat;
		text.x = pos(410);
		text.y = pos(10);
		text.width = pos(1270);
		text.height = pos(40);
		text.textColor = 0xffffffff;
		text.text = "cacheAsBitmap: " + cache;

		rect.cacheAsBitmap = cache;
		content.addChild(rect);
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
		lastTime = timeNow;

		var secPerRev = 60.0 / RPM;
		var percent = timeDiff / secPerRev;
		var angleDiff = percent * 2 * Math.PI;

		angle = angle + angleDiff;

		var xOff = pos(RADIUS) * Math.cos(angle);
		var yOff = pos(RADIUS) * Math.sin(angle);

		rect.x = pos(CENTER_X) + xOff;
		rect.y = pos(CENTER_Y) + yOff;

		if (timeNow >= switchTime)
		{
			textIndex += 1;
			if (textIndex >= textCycle.length)
			{
				textIndex = 0;
			}
			rotatingText.text = textCycle[textIndex];
			if (switchSwitch)
			{
				cache = !cache;
				text.text = "cacheAsBitmap: " + cache;
				rect.cacheAsBitmap = cache;
				switchSwitch = false;
			}
			else
			{
				switchSwitch = true;
			}
			switchTime = timeNow + CHANGE_INTERVAL;
		}
	}
}
