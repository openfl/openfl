package openfl.fl.controls;

import openfl.fl.core.UIComponent;
import openfl.fl.controls.ScrollBar;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl._internal.formats.xfl.display.XFLSprite;
import openfl._internal.formats.xfl.display.XFLMovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.fl.events.ScrollEvent;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;
import openfl._internal.formats.xfl.dom.DOMTimeline;

/**
 * Textarea
 */
class TextArea extends UIComponent
{
	public var maxVerticalScrollPosition(get, never):Int;
	public var verticalScrollPosition(get, set):Int;
	public var maxChars(get, set):Int;
	public var htmlText(get, set):String;
	public var text(get, set):String;
	public var editable(get, set):Bool;

	private var scrollBar:ScrollBar;
	private var textField:TextField;
	private var textFieldNumLinesLast:Int;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.TextArea"));
		textField = new TextField();
		textField.name = "textfield";
		textField.x = 0;
		textField.y = 0;
		textField.type = TextFieldType.INPUT;
		textField.multiline = true;
		textField.wordWrap = true;
		textField.addEventListener(Event.CHANGE, textFieldChangeHandler);
		textFieldNumLinesLast = textField.numLines;
		addChild(textField);
		scrollBar = getXFLScrollBar("UIScrollBar");
		scrollBar.visible = false;
		scrollBar.x = width - scrollBar.width;
		scrollBar.y = 0.0;
		scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollEvent);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		validateNow();
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
			validateNow();
		}
		else
		{
			trace("setStyle(): '" + style + "', " + value);
		}
	}

	public function get_maxVerticalScrollPosition():Int
	{
		return textField.numLines - textField.bottomScrollV + 1;
	}

	public function get_verticalScrollPosition():Int
	{
		return textField.scrollV;
	}

	public function set_verticalScrollPosition(verticalScrollPosition:Int):Int
	{
		textField.scrollV = verticalScrollPosition;
		scrollBar.scrollPosition = verticalScrollPosition - 1;
		return textField.scrollV;
	}

	public function get_maxChars():Int
	{
		return textField.maxChars;
	}

	public function set_maxChars(maxChars:Int):Int
	{
		return textField.maxChars = maxChars;
	}

	public function set_htmlText(_htmlText:String):String
	{
		textField.htmlText = _htmlText;
		validateNow();
		return textField.htmlText;
	}

	public function get_htmlText():String
	{
		return textField.htmlText;
	}

	public function set_text(_text:String):String
	{
		textField.text = _text;
		validateNow();
		return textField.text;
	}

	public function get_text():String
	{
		return textField.text;
	}

	public function get_editable():Bool
	{
		return textField.type == TextFieldType.INPUT;
	}

	public function set_editable(editable:Bool):Bool
	{
		textField.type = editable == true ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		return editable;
	}

	override public function setSize(_width:Float, _height:Float)
	{
		super.setSize(_width, _height);
		textField.width = width - scrollBar.width;
		textField.height = height;
		scrollBar.x = width - scrollBar.width;
		scrollBar.height = height;
		updateTextField();
		updateScrollBar();
		layoutChildren();
	}

	private function updateTextField():Void
	{
		textField.width = width - (scrollBar != null ? scrollBar.width : 0.0);
	}

	private function updateScrollBar():Void
	{
		textFieldNumLinesLast = textField.numLines;
		scrollBar.visibleScrollRange = textField.bottomScrollV;
		scrollBar.pageScrollSize = textField.numLines / scrollBar.visibleScrollRange;
		scrollBar.maxScrollPosition = textField.numLines - scrollBar.visibleScrollRange;
		scrollBar.visible = scrollBar.maxScrollPosition > 0.0;
	}

	private function layoutChildren()
	{
		if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").visible = true;
		if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").visible = true;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").visible = true;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").x = 0.0;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").y = 0.0;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").width = width;
		if (getXFLDisplayObject("TextArea_disabledSkin") != null) getXFLDisplayObject("TextArea_disabledSkin").height = height;
		if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").x = 0.0;
		if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").y = 0.0;
		if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").width = width;
		if (getXFLDisplayObject("TextArea_upSkin") != null) getXFLDisplayObject("TextArea_upSkin").height = height;
	}

	private function onScrollEvent(event:ScrollEvent):Void
	{
		textField.scrollV = Std.int(scrollBar.scrollPosition) + 1;
	}

	private function onMouseWheel(event:MouseEvent):Void
	{
		textField.scrollV = textField.scrollV - event.delta;
		if (scrollBar != null) scrollBar.scrollPosition = textField.scrollV - 1;
	}

	private function textFieldChangeHandler(e:Event):Void
	{
		if (textFieldNumLinesLast != textField.numLines)
		{
			updateTextField();
			updateScrollBar();
			var maxScrollPosition:Int = Std.int(scrollBar.maxScrollPosition);
			var cursorLine = textField.getLineIndexOfChar(textField.caretIndex) + 1;
			if (scrollBar.maxScrollPosition > 0.0 && cursorLine >= textField.scrollV + textField.bottomScrollV)
			{
				scrollBar.scrollPosition++;
				textField.scrollV++;
			}
		}
		dispatchEvent(e);
	}
}
