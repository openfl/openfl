package test;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;
import openfl.utils.Assets;

class UnicodeTest2 extends FunctionalTest
{
	public function new()
	{
		super();
	}

	private function createTextField(fmt:TextFormat, x:Int, y:Int):TextField
	{
		var tf = new TextField();
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.antiAliasType = AntiAliasType.ADVANCED;
		tf.defaultTextFormat = fmt;
		tf.x = x;
		tf.y = y;
		return tf;
	}

	public override function start():Void
	{
		content = new Sprite();

		content.graphics.beginFill(0xFFFFFF, 1.0);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);
		content.graphics.endFill();

		var fmt = new TextFormat("Unifont", 18, 0, false);

		var utf8str = Assets.getText("assets/data.utf8");

		var tf = createTextField(fmt, 50, 50);
		tf.text = utf8str;
		content.addChild(tf);

		// Print out the length of the string
		var tf = createTextField(fmt, 400, 50);
		tf.text = "" + utf8str.length;
		content.addChild(tf);

		// Draw the characters one by one
		for (i in 0...utf8str.length)
		{
			tf = createTextField(fmt, 450 + (i * 30), 50);
			tf.text = utf8str.charAt(i).toString();
			content.addChild(tf);
		}

		// Draw two-character substrings
		for (i in 0...Std.int((utf8str.length / 2)))
		{
			tf = createTextField(fmt, 450 + (i * 60), 100);
			tf.text = utf8str.substr(i * 2, 2).toString();
			content.addChild(tf);
		}
	}

	public override function stop():Void
	{
		content = null;
	}
}
