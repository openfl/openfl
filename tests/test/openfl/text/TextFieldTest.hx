package openfl.text;


import massive.munit.Assert;
import openfl.display.BitmapData;


class TextFieldTest {
	
	
	@Test public function alwaysShowSelection () {
		
		
		
	}
	
	
	@Test public function autoSize () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		Assert.areNotEqual (textField.textWidth + 4, textField.width);
		
		textField.autoSize = TextFieldAutoSize.LEFT;
		
		Assert.areEqual (textField.textWidth + 4, textField.width);
		
		textField.text = "H";
		
		Assert.areEqual (textField.textWidth + 4, textField.width);
		
		textField.text = "Hello World";
		
		Assert.areEqual (textField.textWidth + 4, textField.width);
		
	}
	
	
	@Test public function background () {
		
		var textField = new TextField ();

		Assert.isFalse (textField.background);

		textField.background = true;

		Assert.isTrue (textField.background);

		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		// Need to determine why alpha is FE in native
		Assert.isTrue ((StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFFFFFFFF, 8)) || (StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFEFFFFFF, 8)));
		//Assert.areEqual (StringTools.hex (0xFFFFFFFF, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		
	}
	
	
	@Test public function backgroundColor () {
		
		var textField = new TextField ();
		
		// Need to determine why alpha is FE in native
		Assert.isTrue ((StringTools.hex (textField.backgroundColor, 6) == StringTools.hex (0xFFFFFF, 6)) || (StringTools.hex (textField.backgroundColor, 8) == StringTools.hex (0xFFFFFFFF, 8)));
		//Assert.areEqual (StringTools.hex (0xFFFFFF, 6), StringTools.hex (textField.backgroundColor, 6));

		textField.backgroundColor = 0x00FF00;
		
		Assert.areEqual (StringTools.hex (0x00FF00, 6), StringTools.hex (textField.backgroundColor, 6));

		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		// Need to determine why alpha is FE in native
		Assert.isTrue ((StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFFFFFFFF, 8)) || (StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFEFFFFFF, 8)));
		//Assert.areEqual (StringTools.hex (0xFFFFFFFF, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));

		textField.background = true;

		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		// Need to determine why alpha is FE in native
		Assert.isTrue ((StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFF00FF00, 8)) || (StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFE00FF00, 8)));
		//Assert.areEqual (StringTools.hex (0xFF00FF00, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));

	}
	
	
	@Test public function border () {
		
		var textField = new TextField ();

		Assert.isFalse (textField.border);

		textField.border = true;
		
		Assert.isTrue (textField.border);
		
		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		#if (!cpp && !neko)
		// Looks correct, anti-aliasing is slightly different ATM
		Assert.areEqual (StringTools.hex (0xFF000000, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		#end
	}
	
	
	@Test public function borderColor () {
		
		var textField = new TextField ();

		Assert.areEqual (StringTools.hex (0x000000, 6), StringTools.hex (textField.borderColor, 6));

		textField.borderColor = 0x00FF00;

		Assert.areEqual (StringTools.hex (0x00FF00, 6), StringTools.hex (textField.borderColor, 6));

		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);

		Assert.areEqual (StringTools.hex (0xFFFFFFFF, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));

		textField.border = true;

		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		#if (!cpp && !neko)
		// Looks correct, anti-aliasing is slightly different ATM
		Assert.areEqual (StringTools.hex (0xFF00FF00, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		#end
		
	}
	
	
	@Test public function bottomScrollV () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		Assert.areEqual (1, textField.bottomScrollV);
		
		textField.text = "Hello\nWorld";
		
		Assert.areEqual (2, textField.bottomScrollV);
		
		textField.text = "";
		
		Assert.areEqual (1, textField.bottomScrollV);
		
	}
	
	
	@Test public function caretIndex () {
		
		
		
	}
	
	
	@Test public function condenseWhite () {
		
		
		
	}
	
	
	@Test public function defaultTextFormat () {
		
		
		
	}
	
	
	@Test public function displayAsPassword () {
		
		
		
	}
	
	
	@Test public function embedFonts () {
		
		
		
	}
	
	
	@Test public function gridFitType () {
		
		
		
	}
	
	
	@Test public function htmlText () {
		
		
		
	}
	
	
	@Test public function length () {
		
		
		
	}
	
	
	@Test public function maxChars () {
		
		
		
	}
	
	
	@Test public function maxScrollH () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		Assert.areEqual (0, textField.maxScrollH);
		
	}
	
	
	@Test public function maxScrollV () {
		
		var textField = new TextField ();
		
		Assert.areEqual (1, textField.maxScrollV);
		
		textField.text = "Hello";
		
		Assert.areEqual (1, textField.maxScrollV);
		
		textField.text = "Hello\nWorld\n";
		
		Assert.areEqual (1, textField.maxScrollV);
		
	}
	
	
	@Test public function mouseWheelEnabled () {
		
		
		
	}
	
	
	@Test public function multiline () {
		
		
		
	}
	
	
	@Test public function numLines () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		Assert.areEqual (1, textField.numLines);
		
		textField.text = "Hello\nWorld";
		
		Assert.areEqual (2, textField.numLines);
		
		textField.text = "";
		
		Assert.areEqual (1, textField.numLines);
		
	}
	
	
	@Test public function restrict () {
		
		
		
	}
	
	
	@Test public function scrollH () {
		
		var textField = new TextField ();
		
		Assert.areEqual (0, textField.scrollH);
		
		textField.text = "Hello";
		
		Assert.areEqual (0, textField.scrollH);
		
	}
	
	
	@Test public function scrollV () {
		
		var textField = new TextField ();
		
		Assert.areEqual (1, textField.scrollV);
		
		textField.text = "Hello";
		
		Assert.areEqual (1, textField.scrollV);
		
	}
	
	
	@Test public function selectable () {
		
		
		
	}
	
	
	@Test public function selectedText () {
		
		
		
	}
	
	
	@Test public function selectionBeginIndex () {
		
		
		
	}
	
	
	@Test public function selectionEndIndex () {
		
		
		
	}
	
	
	@Test public function sharpness () {
		
		
		
	}
	
	
	@Test public function styleSheet () {
		
		
		
	}
	
	
	@Test public function text () {
		
		
		
	}
	
	
	@Test public function textColor () {
		
		
		
	}
	
	
	@Test public function textHeight () {
		
		
		
	}
	
	
	@Test public function textInteractionMode () {
		
		
		
	}
	
	
	@Test public function textWidth () {
		
		
		
	}
	
	
	@Test public function thickness () {
		
		
		
	}
	
	
	@Test public function type () {
		
		
		
	}
	
	
	@Test public function useRichTextClipboard () {
		
		
		
	}
	
	
	@Test public function wordWrap () {
		
		
		
	}
	
	
	@Test public function new_ () {
		
		
		
	}
	
	
	@Test public function appendText () {
		
		
		
	}
	
	
	@Test public function copyRichText () {
		
		
		
	}
	
	
	@Test public function getCharBoundaries () {
		
		
		
	}
	
	
	@Test public function getCharIndexAtPoint () {
		
		
		
	}
	
	
	@Test public function getFirstCharInParagraph () {
		
		
		
	}
	
	
	@Test public function getImageReference () {
		
		
		
	}
	
	
	@Test public function getLineIndexAtPoint () {
		
		
		
	}
	
	
	@Test public function getLineIndexOfChar () {
		
		
		
	}
	
	
	@Test public function getLineLength () {
		
		
		
	}
	
	
	@Test public function getLineMetrics () {
		
		
		
	}
	
	
	@Test public function getLineOffset () {
		
		
		
	}
	
	
	@Test public function getLineText () {
		
		
		
	}
	
	
	@Test public function getParagraphLength () {
		
		
		
	}
	
	
	@Test public function getRawText () {
		
		
		
	}
	
	
	@Test public function getTextFormat () {
		
		
		
	}
	
	
	@Test public function getTextRuns () {
		
		
		
	}
	
	
	@Test public function getXMLText () {
		
		
		
	}
	
	
	@Test public function insertXMLText () {
		
		
		
	}
	
	
	@Test public function pasteRichText () {
		
		
		
	}
	
	
	@Test public function replaceSelectedText () {
		
		
		
	}
	
	
	@Test public function replaceText () {
		
		
		
	}
	
	
	@Test public function setSelection () {
		
		
		
	}
	
	
	@Test public function setTextFormat () {
		
		
		
	}
	
	
	@Test public function isFontCompatible () {
		
		
		
	}
	
	
}