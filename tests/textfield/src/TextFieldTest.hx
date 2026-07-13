package;

import openfl.events.Event;
import openfl.errors.RangeError;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class TextFieldTest extends Test
{
	public function test_autoSizeLeft()
	{
		var textField = new TextField();
		textField.text = "Hello";

		Assert.notEquals(textField.textWidth + 4, textField.width);
		Assert.equals(0.0, textField.x);
		Assert.equals(100.0, textField.width);

		textField.autoSize = TextFieldAutoSize.LEFT;

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals(0.0, textField.x);

		textField.text = "H";

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals(0.0, textField.x);

		textField.text = "Hello World";

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals(0.0, textField.x);
	}

	public function test_autoSizeRight()
	{
		var textField = new TextField();
		textField.text = "Hello";

		Assert.notEquals(textField.textWidth + 4, textField.width);
		Assert.equals(0.0, textField.x);
		Assert.equals(100.0, textField.width);

		textField.autoSize = TextFieldAutoSize.RIGHT;

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals(100.0 - textField.textWidth - 4, textField.x);

		textField.text = "H";

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals(100.0 - textField.textWidth - 4, textField.x);

		textField.text = "Hello World";

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals(100.0 - textField.textWidth - 4, textField.x);
	}

	public function test_autoSizeCenter()
	{
		var textField = new TextField();
		textField.text = "Hello";

		Assert.notEquals(textField.textWidth + 4, textField.width);
		Assert.equals(0.0, textField.x);
		Assert.equals(100.0, textField.width);

		textField.autoSize = TextFieldAutoSize.CENTER;

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals((100.0 - (textField.textWidth + 4)) * 0.5, textField.x);

		textField.text = "H";

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals((100.0 - (textField.textWidth + 4)) * 0.5, textField.x);

		textField.text = "Hello World";

		Assert.equals(textField.textWidth + 4, textField.width);
		Assert.equals((100.0 - (textField.textWidth + 4)) * 0.5, textField.x);
	}

	public function test_background()
	{
		var textField = new TextField();

		Assert.isFalse(textField.background);

		textField.background = true;

		Assert.isTrue(textField.background);
	}

	public function test_backgroundColor()
	{
		var textField = new TextField();

		Assert.equals(StringTools.hex(0xFFFFFF, 6), StringTools.hex(textField.backgroundColor, 6));

		textField.backgroundColor = 0x00FF00;

		Assert.equals(StringTools.hex(0x00FF00, 6), StringTools.hex(textField.backgroundColor, 6));
	}

	public function test_border()
	{
		var textField = new TextField();

		Assert.isFalse(textField.border);

		textField.border = true;

		Assert.isTrue(textField.border);
	}

	public function test_borderColor()
	{
		var textField = new TextField();

		Assert.equals(StringTools.hex(0x000000, 6), StringTools.hex(textField.borderColor, 6));

		textField.borderColor = 0x00FF00;

		Assert.equals(StringTools.hex(0x00FF00, 6), StringTools.hex(textField.borderColor, 6));
	}

	public function test_bottomScrollV()
	{
		var textField = new TextField();
		textField.text = "Hello";

		Assert.equals(1, textField.bottomScrollV);

		textField.text = "Hello\nWorld";

		Assert.equals(2, textField.bottomScrollV);

		textField.text = "";

		Assert.equals(1, textField.bottomScrollV);
	}

	public function test_defaultTextFormat()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		var exists = textField.defaultTextFormat;

		Assert.notNull(exists);
	}

	@Ignored
	public function test_displayAsPassword()
	{
		var textField = new TextField();
		textField.text = "Hello";

		var textField2 = new TextField();
		textField2.text = "Hello";
		textField2.displayAsPassword = true;

		var textField3 = new TextField();
		textField3.text = "*****";

		#if flash
		// TODO -- textWidth is still unchanged?
		Assert.equals(textField.textWidth, textField2.textWidth);
		Assert.notEquals(textField3.textWidth, textField2.textWidth);
		#end
	}

	public function test_embedFonts()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		var exists = textField.embedFonts;

		Assert.isFalse(exists);
	}

	public function test_gridFitType()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		var exists = textField.gridFitType;

		Assert.notNull(exists);
	}

	public function test_htmlText()
	{
		// TODO: Confirm functionality

		var textField = new TextField();

		Assert.equals("", textField.htmlText);

		textField.htmlText = "<b>Hello</b> <i>World</i>";

		// the HTML may not be exactly the same, so just confirm that it's not
		// any empty string anymore
		Assert.notEquals("", textField.htmlText);

		Assert.equals("Hello World", textField.text);

		textField.text = "";

		Assert.equals("", textField.htmlText);

		#if flash
		textField.text = "<b>Hello</b> <i>World</i>";
		Assert.isTrue(textField.htmlText.indexOf("&lt;b&gt;Hello&lt;/b&gt; &lt;i&gt;World&lt;/i&gt;") != -1);
		#else
		// TODO: fix me
		#end
	}

	public function test_maxChars()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		var exists = textField.maxChars;

		Assert.equals(0, exists);
	}

	public function test_maxScrollH()
	{
		var textField = new TextField();
		Assert.equals(0, textField.maxScrollH);

		textField.text = "Hello";

		Assert.equals(0, textField.maxScrollH);
	}

	public function test_maxScrollV()
	{
		var textField = new TextField();

		Assert.equals(1, textField.maxScrollV);

		textField.text = "Hello";

		Assert.equals(1, textField.maxScrollV);

		textField.text = "Hello\nWorld\n";

		Assert.equals(1, textField.maxScrollV);

		textField.multiline = true;

		Assert.equals(1, textField.maxScrollV);

		textField.text = "Hello\n\nWorld\n\nHello\n\nWorld\n\n";

		#if !flash // sometimes 3, not 2?

		#if !html5
		// Assert.equals (2, textField.maxScrollV);
		Assert.isTrue(textField.maxScrollV == 2 || textField.maxScrollV == 3);
		#end

		textField.height = 10;

		#if flash
		// should we replicate not updating until text is changed?
		Assert.equals(2, textField.maxScrollV);
		#end
		#end

		textField.text = textField.text;

		#if (!flash && !html5) // sometimes 10, not 9?

		// Assert.equals (9, textField.maxScrollV);
		// Assert.isTrue(textField.maxScrollV == 9 || textField.maxScrollV == 10);
		#end
	}

	public function test_multiline()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		var exists = textField.multiline;

		Assert.isFalse(exists);
	}

	public function test_numLines()
	{
		var textField = new TextField();
		textField.text = "Hello";

		Assert.equals(1, textField.numLines);

		textField.text = "Hello\nWorld";

		Assert.equals(2, textField.numLines);

		textField.text = "";

		Assert.equals(1, textField.numLines);
	}

	public function test_scrollH()
	{
		var textField = new TextField();

		Assert.equals(0, textField.scrollH);

		textField.text = "Hello";

		Assert.equals(0, textField.scrollH);
	}

	public function test_setScrollHNegative()
	{
		var textField = new TextField();

		textField.text = "Hi";

		Assert.equals(0, textField.scrollH);
		Assert.equals(0, textField.maxScrollH);

		var scrolled = false;
		textField.addEventListener(Event.SCROLL, function(event:Event):Void
		{
			scrolled = true;
		});

		textField.scrollH = -1;

		Assert.isFalse(scrolled);
		Assert.equals(0, textField.scrollH);
		Assert.equals(0, textField.maxScrollH);
	}

	public function test_setScrollHHigherThanMaxScrollH()
	{
		var textField = new TextField();

		textField.text = "Hi";

		Assert.equals(0, textField.scrollH);
		Assert.equals(0, textField.maxScrollH);

		var scrolled = false;
		textField.addEventListener(Event.SCROLL, function(event:Event):Void
		{
			scrolled = true;
		});

		textField.scrollH = 1;

		Assert.isFalse(scrolled);
		Assert.equals(0, textField.scrollH);
		Assert.equals(0, textField.maxScrollH);
	}

	public function test_scrollV()
	{
		var textField = new TextField();

		Assert.equals(1, textField.scrollV);

		textField.text = "Hello";

		Assert.equals(1, textField.scrollV);

		textField.text = "Hello\nWorld";
		textField.height = 20;
		textField.multiline = true;

		#if flash
		textField.text = textField.text;
		#end

		var textField2 = new TextField();
		textField2.height = 20;
		textField2.text = "World";

		textField.scrollV = 2;
	}

	public function test_setScrollVNegative()
	{
		var textField = new TextField();

		textField.text = "Hello";

		Assert.equals(1, textField.scrollV);
		Assert.equals(1, textField.maxScrollV);

		var scrolled = false;
		textField.addEventListener(Event.SCROLL, function(event:Event):Void
		{
			scrolled = true;
		});

		textField.scrollV = -1;

		Assert.isFalse(scrolled);
		Assert.equals(1, textField.scrollV);
		Assert.equals(1, textField.maxScrollV);
	}

	public function test_setScrollVHigherThanMaxScrollV()
	{
		var textField = new TextField();

		textField.text = "Hello";

		Assert.equals(1, textField.scrollV);
		Assert.equals(1, textField.maxScrollV);

		var scrolled = false;
		textField.addEventListener(Event.SCROLL, function(event:Event):Void
		{
			scrolled = true;
		});

		textField.scrollV = 2;

		Assert.isFalse(scrolled);
		Assert.equals(1, textField.scrollV);
		Assert.equals(1, textField.maxScrollV);
	}

	public function test_selectable()
	{
		var textField = new TextField();

		Assert.isTrue(textField.selectable);

		textField.selectable = false;

		Assert.isFalse(textField.selectable);
	}

	public function test_sharpness()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		var exists = textField.sharpness;

		Assert.notNull(exists);
	}

	public function test_tabEnabled()
	{
		var textField = new TextField();
		Assert.isFalse(textField.tabEnabled);

		textField.type = INPUT;
		Assert.isTrue(textField.tabEnabled);

		textField.tabEnabled = false;
		Assert.isFalse(textField.tabEnabled);

		textField.type = DYNAMIC;
		textField.type = INPUT;
		Assert.isFalse(textField.tabEnabled);

		textField.type = DYNAMIC;
		textField.tabEnabled = true;
		Assert.isTrue(textField.tabEnabled);
	}

	public function test_text()
	{
		var textField = new TextField();

		Assert.equals("", textField.text);

		textField.text = "Hello";

		Assert.equals("Hello", textField.text);
	}

	public function test_textColor()
	{
		var textField = new TextField();

		Assert.equals(0x000000, textField.textColor);

		textField.textColor = 0xff00ff;

		Assert.equals(0xff00ff, textField.textColor);

		textField.defaultTextFormat = new TextFormat("_sans", 12, 0x00ff00);

		Assert.equals(0x00ff00, textField.textColor);
	}

	public function test_textHeight()
	{
		var textField = new TextField();

		Assert.equals(0.0, textField.textHeight);

		textField.text = "Hello";

		Assert.isTrue(textField.textHeight > 0.0);
	}

	public function test_textWidth()
	{
		var textField = new TextField();

		Assert.equals(0.0, textField.textWidth);

		textField.text = "Hello";

		#if (lime && tools)
		// TODO: the hxp version doesn't measure correctly
		Assert.isTrue(textField.textWidth > 0.0);
		#end
	}

	public function test_type()
	{
		var textField = new TextField();
		Assert.equals(TextFieldType.DYNAMIC, textField.type);

		textField.type = TextFieldType.INPUT;
		Assert.equals(TextFieldType.INPUT, textField.type);
	}

	public function test_wordWrap()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		var exists = textField.wordWrap;

		Assert.isFalse(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		Assert.notNull(textField);
	}

	public function test_appendText()
	{
		var textField = new TextField();

		Assert.equals("", textField.text);

		textField.appendText("Hello");

		Assert.equals("Hello", textField.text);

		textField.appendText(" World");

		Assert.equals("Hello World", textField.text);
	}

	public function test_getLineMetrics()
	{
		// TODO: Confirm functionality

		var textField = new TextField();
		var exists = textField.getLineMetrics;

		Assert.notNull(exists);
	}

	public function test_getLineOffset()
	{
		var textField = new TextField();

		Assert.equals(0, textField.getLineOffset(0));
		#if flash
		Assert.raises(function():Void
		{
			textField.getLineOffset(1);
		}, RangeError);
		#else
		Assert.equals(-1, textField.getLineOffset(1));
		#end
		Assert.raises(function():Void
		{
			textField.getLineOffset(-1);
		}, RangeError);

		textField.text = "Hello";

		Assert.equals(0, textField.getLineOffset(0));
		#if flash
		Assert.raises(function():Void
		{
			textField.getLineOffset(1);
		}, RangeError);
		#else
		Assert.equals(-1, textField.getLineOffset(1));
		#end

		textField.text = "Hello\n";

		#if flash
		Assert.equals(0, textField.getLineOffset(0));
		Assert.equals(6, textField.getLineOffset(1));
		Assert.raises(function():Void
		{
			textField.getLineOffset(2);
		}, RangeError);
		#else
		Assert.equals(0, textField.getLineOffset(0));
		// TODO: line index 1 should be an empty string, like flash
		Assert.equals(-1, textField.getLineOffset(1));
		Assert.equals(-1, textField.getLineOffset(2));
		#end

		textField.text = "Hello\nWorld";

		#if flash
		Assert.equals(0, textField.getLineOffset(0));
		Assert.equals(6, textField.getLineOffset(1));
		Assert.raises(function():Void
		{
			textField.getLineOffset(2);
		}, RangeError);
		#else
		Assert.equals(0, textField.getLineOffset(0));
		Assert.equals(6, textField.getLineOffset(1));
		Assert.equals(-1, textField.getLineOffset(2));
		#end
	}

	public function test_getLineText()
	{
		var textField = new TextField();

		Assert.equals("", textField.getLineText(0));
		#if flash
		Assert.raises(function():Void
		{
			textField.getLineText(1);
		}, RangeError);
		#else
		Assert.isNull(textField.getLineText(1));
		#end
		Assert.raises(function():Void
		{
			textField.getLineText(-1);
		}, RangeError);

		textField.text = "Hello";

		Assert.equals("Hello", textField.getLineText(0));
		#if flash
		Assert.raises(function():Void
		{
			textField.getLineText(1);
		}, RangeError);
		#else
		Assert.isNull(textField.getLineText(1));
		#end

		textField.text = "Hello\n";

		#if flash
		Assert.equals("Hello\r", textField.getLineText(0));
		Assert.equals("", textField.getLineText(1));
		Assert.raises(function():Void
		{
			textField.getLineText(2);
		}, RangeError);
		#else
		Assert.equals("Hello\n", textField.getLineText(0));
		// TODO: line index 1 should be an empty string, like flash
		Assert.isNull(textField.getLineText(1));
		Assert.isNull(textField.getLineText(2));
		#end

		textField.text = "Hello\nWorld";

		#if flash
		Assert.equals("Hello\r", textField.getLineText(0));
		Assert.equals("World", textField.getLineText(1));
		Assert.raises(function():Void
		{
			textField.getLineText(2);
		}, RangeError);
		#else
		Assert.equals("Hello\n", textField.getLineText(0));
		Assert.equals("World", textField.getLineText(1));
		Assert.isNull(textField.getLineText(2));
		#end
	}

	public function test_getTextFormat()
	{
		var textField = new TextField();
		var textFormat = textField.getTextFormat();

		Assert.notNull(textFormat);
		Assert.equals(null, textFormat.font);
		Assert.equals(null, textFormat.size);

		var textFormat1 = new TextFormat("_sans", 20, 0xFF0000);
		var textFormat2 = new TextFormat("_serif", 40);

		textField.setTextFormat(textFormat1);

		Assert.notNull(textFormat);
		Assert.equals(null, textFormat.font);
		Assert.equals(null, textFormat.size);

		textField.text = "1234";
		textField.setTextFormat(textFormat1, 0, 4);
		textField.setTextFormat(textFormat2, 2, 4);

		var textFormat = textField.getTextFormat();

		Assert.notNull(textFormat);
		Assert.equals(null, textFormat.font);
		Assert.equals(null, textFormat.size);
		Assert.equals(0xFF0000, textFormat.color);

		var textFormat = textField.getTextFormat(0, 2);

		Assert.notNull(textFormat);
		Assert.equals(textFormat1.font, textFormat.font);
		Assert.equals(textFormat1.size, textFormat.size);
		Assert.equals(textFormat1.color, textFormat.color);

		var textFormat = textField.getTextFormat(2, 4);

		Assert.notNull(textFormat);
		Assert.equals(textFormat2.font, textFormat.font);
		Assert.equals(textFormat2.size, textFormat.size);
		Assert.equals(textFormat1.color, textFormat.color);
	}

	public function test_setSelection()
	{
		var textField = new TextField();

		Assert.equals(0, textField.selectionBeginIndex);
		Assert.equals(0, textField.selectionEndIndex);

		textField.text = "Hello";

		Assert.equals(0, textField.selectionBeginIndex);
		Assert.equals(0, textField.selectionEndIndex);

		textField.setSelection(1, 3);

		Assert.equals(1, textField.selectionBeginIndex);
		Assert.equals(3, textField.selectionEndIndex);

		textField.setSelection(4, 2);

		Assert.equals(2, textField.selectionBeginIndex);
		Assert.equals(4, textField.selectionEndIndex);

		textField.text = "";

		Assert.equals(0, textField.selectionBeginIndex);
		Assert.equals(0, textField.selectionEndIndex);
	}

	public function test_setTextFormat()
	{
		var textField = new TextField();
		textField.htmlText = "<font color='#FF0000'>Hello</font> - World\n<font color='#00FF00'>Goodbye </font>- World";
		var textFormat = textField.getTextFormat();
		textField.setTextFormat(textFormat);

		var check = textField.getTextFormat(0, 4);
		Assert.equals(0xFF0000, check.color);
	}

	public function test_setDecimalEntityCode()
	{
		var textField = new TextField();
		textField.htmlText = "&#38;";
		Assert.equals("&", textField.text);
	}

	public function test_setHexEntityCode()
	{
		var textField = new TextField();
		textField.htmlText = "&#x27;";
		Assert.equals("'", textField.text);
	}

	public function test_autoSizeHeightWithFinalNewLine()
	{
		var textField = new TextField();
		textField.autoSize = LEFT;
		textField.multiline = true;
		textField.text = "hello";
		var textFieldHeight1 = textField.height;
		textField.text = "hello\n";
		var textFieldHeight2 = textField.height;
		// the final new line is not counted for type != INPUT
		Assert.equals(textFieldHeight1, textFieldHeight2);
		textField.text = "hello\n\n";
		var textFieldHeight3 = textField.height;
		// for multiple final new lines, don't count the last one
		Assert.notEquals(textFieldHeight2, textFieldHeight3);

		var textField2 = new TextField();
		textField2.autoSize = LEFT;
		textField2.type = TextFieldType.INPUT;
		textField2.multiline = true;
		textField2.text = "hello";
		var textField2Height1 = textField2.height;
		textField2.text = "hello\n";
		var textField2Height2 = textField2.height;
		// the final new line is counted for type == INPUT
		Assert.notEquals(textField2Height1, textField2Height2);
	}

	public function test_clearSelectionOnSetText()
	{
		var textField = new TextField();
		textField.text = "hello";
		textField.setSelection(1, 3);
		Assert.equals(1, textField.selectionBeginIndex);
		Assert.equals(3, textField.selectionEndIndex);
		textField.text = "world";
		Assert.equals(0, textField.selectionBeginIndex);
		Assert.equals(0, textField.selectionEndIndex);
	}

	public function test_clearSelectionOnPlusAssignText()
	{
		var textField = new TextField();
		textField.text = "hello";
		textField.setSelection(1, 3);
		Assert.equals(1, textField.selectionBeginIndex);
		Assert.equals(3, textField.selectionEndIndex);
		textField.text += " world";
	}

	public function test_clearSelectionOnAppendText()
	{
		var textField = new TextField();
		textField.text = "hello";
		textField.setSelection(1, 3);
		Assert.equals(1, textField.selectionBeginIndex);
		Assert.equals(3, textField.selectionEndIndex);
		textField.appendText(" world");
		#if flash
		// for some reason, flash keeps the same selection, unless the
		// TextField receives focus between setSelection() and appendText()
		Assert.equals(1, textField.selectionBeginIndex);
		Assert.equals(3, textField.selectionEndIndex);
		#else
		Assert.equals(11, textField.selectionBeginIndex);
		Assert.equals(11, textField.selectionEndIndex);
		#end
	}

	public function test_clearSelectionOnSetHtmlText()
	{
		var textField = new TextField();
		textField.htmlText = "hello";
		textField.setSelection(1, 3);
		Assert.equals(1, textField.selectionBeginIndex);
		Assert.equals(3, textField.selectionEndIndex);
		textField.htmlText = "world";
		Assert.equals(5, textField.selectionBeginIndex);
		Assert.equals(5, textField.selectionEndIndex);
	}

	#if lime_tools
	public function test_autoSizeWithChangedFontSize()
	{
		var tf = new TextField();
		tf.autoSize = LEFT;
		tf.defaultTextFormat = new TextFormat("_sans", 18, 0xff0000);
		tf.text = "hello";
		var originalWidth = tf.width;
		var originalHeight = tf.height;
		tf.defaultTextFormat = new TextFormat("_sans", 24, 0xff0000);
		tf.text = "hello";
		var largerWidth = tf.width;
		var largerHeight = tf.height;
		// the font size increased, so the width and height should too
		Assert.isTrue(largerWidth > originalWidth);
		Assert.isTrue(largerHeight > originalHeight);
		tf.defaultTextFormat = new TextFormat("_sans", 12, 0xff0000);
		tf.text = "hello";
		var smallerWidth = tf.width;
		var smallerHeight = tf.height;
		// the font size decreased, so the width and height should too
		Assert.isTrue(smallerWidth < originalWidth);
		Assert.isTrue(smallerHeight < originalHeight);
	}

	public function test_autoSizeLeft()
	{
		var textField = new TextField();
		textField.text = "Hello";
	#end

	#if !flash
	public function test_mouseDownAndMouseUpEventAtSamePosition()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping TextField mouseDown/mouseUp test");
			return;
		}

		var stage = Lib.current.stage;

		var tf = new TextField();
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = "Hello";
		tf.x = 20.0;
		tf.y = 30.0;
		Lib.current.addChild(tf);

		Assert.equals(0, tf.selectionBeginIndex);
		Assert.equals(0, tf.selectionEndIndex);

		stage.window.onMouseDown.dispatch(tf.x + tf.width / 2.0, tf.y + tf.height / 2.0, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(tf.selectionBeginIndex > 0);
		Assert.equals(tf.selectionBeginIndex, tf.selectionEndIndex);

		stage.window.onMouseUp.dispatch(tf.x + tf.width / 2.0, tf.y + tf.height / 2.0, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(tf.selectionBeginIndex > 0);
		Assert.equals(tf.selectionBeginIndex, tf.selectionEndIndex);

		tf.parent.removeChild(tf);
	}

	public function test_mouseDownMouseMoveAndMouseUpEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping TextField mouseDown/mouseMove/mouseUp test");
			return;
		}

		var stage = Lib.current.stage;

		var tf = new TextField();
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = "Hello";
		tf.x = 20.0;
		tf.y = 30.0;
		Lib.current.addChild(tf);

		Assert.equals(0, tf.selectionBeginIndex);
		Assert.equals(0, tf.selectionEndIndex);

		var xPos = tf.x + tf.width / 2.0;
		var yPos = tf.y + tf.height / 2.0;

		stage.window.onMouseDown.dispatch(xPos, yPos, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(tf.selectionBeginIndex > 0);
		Assert.equals(tf.selectionBeginIndex, tf.selectionEndIndex);

		var prevSelectionBeginIndex = tf.selectionBeginIndex;
		var prevSelectionEndIndex = tf.selectionEndIndex;

		xPos += 100.0;
		stage.window.onMouseMove.dispatch(xPos, yPos);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.equals(prevSelectionBeginIndex, tf.selectionBeginIndex);
		Assert.isTrue(tf.selectionEndIndex > prevSelectionEndIndex);

		prevSelectionBeginIndex = tf.selectionBeginIndex;
		prevSelectionEndIndex = tf.selectionEndIndex;

		stage.window.onMouseUp.dispatch(xPos, yPos, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		// mouse hasn't moved again, so no change
		Assert.equals(prevSelectionBeginIndex, tf.selectionBeginIndex);
		Assert.equals(prevSelectionEndIndex, tf.selectionEndIndex);

		tf.parent.removeChild(tf);
	}

	public function test_setSelectionBetweenMouseDownAndMouseUp()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping TextField setSelection between mouseDown/mouseUp test");
			return;
		}

		var stage = Lib.current.stage;

		var tf = new TextField();
		tf.autoSize = LEFT;
		tf.text = "Hello";
		tf.x = 20.0;
		tf.y = 30.0;
		Lib.current.addChild(tf);

		// ensure that __transformDirty flag is cleared
		@:privateAccess tf.stage.__renderAfterEvent();

		Assert.equals(0, tf.selectionBeginIndex);
		Assert.equals(0, tf.selectionEndIndex);

		var xPos = tf.x + tf.width / 2.0;
		var yPos = tf.y + tf.height / 2.0;

		stage.window.onMouseDown.dispatch(xPos, yPos, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(tf.selectionBeginIndex > 0);
		Assert.equals(tf.selectionBeginIndex, tf.selectionEndIndex);

		tf.setSelection(0, tf.text.length);

		Assert.equals(0, tf.selectionBeginIndex);
		Assert.equals(tf.text.length, tf.selectionEndIndex);

		stage.window.onMouseUp.dispatch(xPos, yPos, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		// mouse hasn't moved again, so no change
		Assert.equals(0, tf.selectionBeginIndex);
		Assert.equals(tf.text.length, tf.selectionEndIndex);

		tf.parent.removeChild(tf);
	}
	#end
}
