package openfl.text;


import massive.munit.Assert;
import openfl.display.BitmapData;


class TextFieldTest {
	
	
	/*@Ignore @Test*/ public function alwaysShowSelection () {
		
		
		
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
	
	
	/*@Ignore @Test*/ public function caretIndex () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function condenseWhite () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function defaultTextFormat () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function displayAsPassword () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function embedFonts () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function gridFitType () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function htmlText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function length () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function maxChars () {
		
		
		
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
	
	
	/*@Ignore @Test*/ public function mouseWheelEnabled () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function multiline () {
		
		
		
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
	
	
	/*@Ignore @Test*/ public function restrict () {
		
		
		
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
	
	
	/*@Ignore @Test*/ public function selectable () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function selectedText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function selectionBeginIndex () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function selectionEndIndex () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function sharpness () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function styleSheet () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function text () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function textColor () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function textHeight () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function textInteractionMode () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function textWidth () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function thickness () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function type () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function useRichTextClipboard () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function wordWrap () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function new_ () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function appendText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function copyRichText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getCharBoundaries () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getCharIndexAtPoint () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getFirstCharInParagraph () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getImageReference () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getLineIndexAtPoint () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getLineIndexOfChar () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getLineLength () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getLineMetrics () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getLineOffset () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getLineText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getParagraphLength () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getRawText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getTextFormat () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getTextRuns () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function getXMLText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function insertXMLText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function pasteRichText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function replaceSelectedText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function replaceText () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function setSelection () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function setTextFormat () {
		
		
		
	}
	
	
	/*@Ignore @Test*/ public function isFontCompatible () {
		
		
		
	}
	
	
}