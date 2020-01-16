package openfl.fl.controls;

import openfl.fl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl._internal.formats.xfl.display.XFLSprite;
import openfl._internal.formats.xfl.display.XFLMovieClip;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;

/**
 * Text input
 */
class TextInput extends UIComponent
{
	public var horizontalScrollPosition:Float;
	public var htmlText(get, set):String;
	public var text(get, set):String;
	public var editable:Bool;

	private var textField:TextField;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.TextInput"));
		textField = new TextField();
		textField.name = "textfield";
		textField.x = 0;
		textField.y = 0;
		textField.type = TextFieldType.INPUT;
		textField.multiline = false;
		textField.wordWrap = false;
		addChild(textField);
		updateTextField();
		layoutChildren();
	}

	override public function drawFocus(draw:Bool):Void
	{
		trace("drawFocus(): " + draw);
	}

	override public function setStyle(style:String, value:Dynamic):Void
	{
		if (style == "textFormat")
		{
			var textFormat:TextFormat = cast(value, TextFormat);
			textField.setTextFormat(textFormat);
			updateTextField();
		}
		else
		{
			trace("setStyle(): '" + style + "', " + value);
		}
	}

	public function set_htmlText(_htmlText:String):String
	{
		textField.htmlText = _htmlText;
		updateTextField();
		return textField.htmlText;
	}

	public function get_htmlText():String
	{
		return textField.htmlText;
	}

	public function set_text(_text:String):String
	{
		textField.text = _text;
		updateTextField();
		return textField.text;
	}

	public function get_text():String
	{
		return textField.text;
	}

	override public function setSize(_width:Float, _height:Float)
	{
		super.setSize(_width, _height);
		updateTextField();
		layoutChildren();
	}

	private function updateTextField():Void
	{
		textField.width = width;
		textField.height = height;
	}

	private function layoutChildren() {}
}
