package test;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

class UnicodeTest1 extends FunctionalTest
{
	private static var NUM_COLUMNS = 16;
	private static var NUM_ROWS = 20;

	private var lineOffset:Int;
	private var lines:Array<Array<TextField>>;
	private var rows:Array<TextField>;

	public function new()
	{
		super();
	}

	private function createTextField(fmt:TextFormat, x:Int, y:Int):TextField
	{
		var tf = new TextField();
		tf.antiAliasType = AntiAliasType.ADVANCED;
		tf.defaultTextFormat = fmt;
		tf.x = x;
		tf.y = y;
		return tf;
	}

	public override function start():Void
	{
		content = new Sprite();

		lineOffset = 0;

		rows = new Array<TextField>();
		lines = new Array<Array<TextField>>();

		content.graphics.beginFill(0xFFFFFF, 1.0);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);
		content.graphics.endFill();

		var fmt = new TextFormat("Unifont", 18, 0, false);

		for (x in 0...NUM_COLUMNS)
		{
			var tf = createTextField(fmt, 200 + (50 * x), 20);
			tf.text = "" + x;
			content.addChild(tf);
		}

		for (y in 0...NUM_ROWS)
		{
			var tf = createTextField(fmt, 100, 75 + (30 * y));
			rows.push(tf);
			content.addChild(tf);
		}

		for (y in 0...NUM_ROWS)
		{
			var line = new Array<TextField>();
			lines.push(line);
			for (x in 0...NUM_COLUMNS)
			{
				var tf = createTextField(fmt, 200 + (50 * x), 75 + (30 * y));
				content.addChild(tf);
				line.push(tf);
			}
		}

		updateAllText();

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
	}

	public override function stop():Void
	{
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
		content = null;
	}

	public function onKey(event:KeyboardEvent):Void
	{
		var maxLineOffset = Std.int(0x10FFFF / NUM_COLUMNS);

		if (event.keyCode == Keyboard.DOWN)
		{
			if (lineOffset < maxLineOffset)
			{
				lineOffset += 1;
				updateAllText();
			}
		}
		else if (event.keyCode == Keyboard.RIGHT)
		{
			var lo = lineOffset + 16;
			if (lo > maxLineOffset)
			{
				lo = maxLineOffset;
			}
			if (lo != lineOffset)
			{
				lineOffset = lo;
				updateAllText();
			}
		}
		else if (event.keyCode == Keyboard.UP)
		{
			if (lineOffset > 0)
			{
				lineOffset -= 1;
				updateAllText();
			}
		}
		else if (event.keyCode == Keyboard.LEFT)
		{
			var lo = lineOffset - 16;
			if (lo < 0)
			{
				lo = 0;
			}
			if (lo != lineOffset)
			{
				lineOffset = lo;
				updateAllText();
			}
		}
	}

	private function updateAllText():Void
	{
		for (y in 0...NUM_ROWS)
		{
			for (x in 0...NUM_COLUMNS)
			{
				var unicode = ((y + lineOffset) * NUM_COLUMNS) + x;
				if (unicode <= 0x10FFFF)
				{
					lines[y][x].text = String.fromCharCode(unicode);
				}
			}
			var hex = StringTools.hex((y + lineOffset) * NUM_COLUMNS);
			var text = "0x";
			for (i in 0...(6 - hex.length))
			{
				text += "0";
			}
			rows[y].text = text + hex;
		}
	}
}
