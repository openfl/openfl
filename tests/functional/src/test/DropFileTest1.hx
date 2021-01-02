package test;

import lime.app.Application;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * TODO: Create separate Lime testing instead?
 */
class DropFileTest1 extends FunctionalTest
{
	private var textField:TextField;

	public function new()
	{
		super();
	}

	public override function start():Void
	{
		Application.current.window.onDropFile.add(window_onDropFile);

		textField = new TextField();
		var textFormat = new TextFormat("_sans", 20);
		textField.width = contentWidth - 40;
		textField.x = 20;
		textField.y = 20;
		textField.defaultTextFormat = textFormat;
		content.addChild(textField);
	}

	public override function stop():Void
	{
		Application.current.window.onDropFile.remove(window_onDropFile);
		content.removeChild(textField);
	}

	private function window_onDropFile(path:String):Void
	{
		textField.text = Std.string(path);
	}
}
