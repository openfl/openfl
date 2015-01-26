package openfl.text;


import massive.munit.Assert;
import openfl.display.BitmapData;


class TextFieldTest {
	
	
	@Test public function autoSize () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		#if !lime_legacy
		
		Assert.areNotEqual (textField.textWidth + 4, textField.width);
		
		textField.autoSize = TextFieldAutoSize.LEFT;
		
		Assert.areEqual (textField.textWidth + 4, textField.width);
		
		textField.text = "H";
		
		Assert.areEqual (textField.textWidth + 4, textField.width);
		
		textField.text = "Hello World";
		
		Assert.areEqual (textField.textWidth + 4, textField.width);
		
		#end
		
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
		#if (flash || lime_legacy)
		Assert.isTrue ((StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFF00FF00, 8)) || (StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFE00FF00, 8)));
		#end
		//Assert.areEqual (StringTools.hex (0xFF00FF00, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));

	}
	
	
	@Test public function border () {
		
		var textField = new TextField ();

		Assert.isFalse (textField.border);

		textField.border = true;
		
		Assert.isTrue (textField.border);
		
		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		#if (!cpp && !neko && !js)
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
		
		#if (!cpp && !neko && !js)
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
	
	
	@Test public function defaultTextFormat () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.defaultTextFormat;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function displayAsPassword () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.displayAsPassword;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function embedFonts () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.embedFonts;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function gridFitType () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.gridFitType;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function htmlText () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.htmlText;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function maxChars () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.maxChars;
		
		Assert.isNotNull (exists);
		
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
	
	
	@Test public function multiline () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.multiline;
		
		Assert.isFalse (exists);
		
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
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.selectable;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function sharpness () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.sharpness;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function text () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.text;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function textColor () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textColor;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function textHeight () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textHeight;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function textWidth () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textWidth;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function type () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.type;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function wordWrap () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.wordWrap;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		Assert.isNotNull (textField);
		
	}
	
	
	@Test public function appendText () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.appendText;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getLineMetrics () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineMetrics;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getLineOffset () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineOffset;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getLineText () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineText;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getTextFormat () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getTextFormat;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setSelection () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.setSelection;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setTextFormat () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.setTextFormat;
		
		Assert.isNotNull (exists);
		
	}
	
	
}