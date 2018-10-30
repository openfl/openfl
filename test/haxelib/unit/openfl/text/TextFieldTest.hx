package openfl.text;


import massive.munit.Assert;
import openfl.display.BitmapData;


class TextFieldTest {
	
	
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
		
		Assert.areEqual (StringTools.hex (0xFFFFFFFF, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		
	}
	
	
	@Test public function backgroundColor () {
		
		var textField = new TextField ();
		
		Assert.areEqual (StringTools.hex (0xFFFFFF, 6), StringTools.hex (textField.backgroundColor, 6));
		
		textField.backgroundColor = 0x00FF00;
		
		Assert.areEqual (StringTools.hex (0x00FF00, 6), StringTools.hex (textField.backgroundColor, 6));
		
		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		Assert.areEqual (StringTools.hex (0xFFFFFFFF, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		
		textField.background = true;
		
		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		Assert.areEqual (StringTools.hex (0xFF00FF00, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		
	}
	
	
	@Test public function border () {
		
		var textField = new TextField ();
		
		Assert.isFalse (textField.border);
		
		textField.border = true;
		
		Assert.isTrue (textField.border);
		
		var bitmapData = new BitmapData (Std.int (textField.width), Std.int (textField.height));
		bitmapData.draw (textField);
		
		Assert.areEqual (StringTools.hex (0xFF000000, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		
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
		
		Assert.areEqual (StringTools.hex (0xFF00FF00, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		
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
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		var textField2 = new TextField ();
		textField2.text = "Hello";
		textField2.displayAsPassword = true;
		
		var textField3 = new TextField ();
		textField3.text = "*****";
		
		#if flash
		// TODO -- textWidth is still unchanged?
		Assert.areEqual (textField.textWidth, textField2.textWidth);
		Assert.areNotEqual (textField3.textWidth, textField2.textWidth);
		#end
		
		var bitmapData = new BitmapData (Math.ceil (textField.width), Math.ceil (textField.height), true);
		var bitmapData2 = bitmapData.clone ();
		var bitmapData3 = bitmapData.clone ();
		
		bitmapData.draw (textField);
		bitmapData2.draw (textField2);
		bitmapData3.draw (textField3);
		
		Assert.isTrue (Std.is (bitmapData2.compare (bitmapData), BitmapData));
		Assert.areEqual (0, bitmapData2.compare (bitmapData3));
		
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
		
		textField.multiline = true;
		
		Assert.areEqual (1, textField.maxScrollV);
		
		textField.text = "Hello\n\nWorld\n\nHello\n\nWorld\n\n";
		
		#if !flash // sometimes 3, not 2?
		
		#if !html5
		//Assert.areEqual (2, textField.maxScrollV);
		Assert.isTrue (textField.maxScrollV == 2 || textField.maxScrollV == 3);
		#end
		
		textField.height = 10;
		
		#if flash
		// should we replicate not updating until text is changed?
		Assert.areEqual (2, textField.maxScrollV);
		#end
		
		#end
		
		textField.text = textField.text;
		
		#if (!flash && !html5) // sometimes 10, not 9?
		
		//Assert.areEqual (9, textField.maxScrollV);
		Assert.isTrue (textField.maxScrollV == 9 || textField.maxScrollV == 10);
		
		#end
		
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
		
		textField.text = "Hello\nWorld";
		textField.height = 20;
		textField.multiline = true;
		
		#if flash
		textField.text = textField.text;
		#end
		
		var textField2 = new TextField ();
		textField2.height = 20;
		textField2.text = "World";
		
		textField.scrollV = 2;
		
		var bitmapData = new BitmapData (Math.ceil (textField.width), Math.ceil (textField.height), true);
		var bitmapData2 = bitmapData.clone ();
		
		bitmapData.draw (textField);
		bitmapData2.draw (textField2);
		
		Assert.areEqual (0, bitmapData.compare (bitmapData2));
		
		textField.scrollV = 1000;
		
		Assert.areEqual (textField.maxScrollV, textField.scrollV);
		
		var bitmapData = new BitmapData (Math.ceil (textField.width), Math.ceil (textField.height), true);
		bitmapData.draw (textField);
		
		Assert.areEqual (0, bitmapData.compare (bitmapData2));
		
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
	
	
	@Test public function tabEnabled () {
		
		var textField = new TextField ();
		Assert.isFalse (textField.tabEnabled);
		
		textField.type = INPUT;
		Assert.isTrue (textField.tabEnabled);
		
		textField.tabEnabled = false;
		Assert.isFalse (textField.tabEnabled);
		
		textField.type = DYNAMIC;
		textField.type = INPUT;
		Assert.isFalse (textField.tabEnabled);
		
		textField.type = DYNAMIC;
		textField.tabEnabled = true;
		Assert.isTrue (textField.tabEnabled);
		
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
		var textFormat = textField.getTextFormat ();
		
		Assert.isNotNull (textFormat);
		Assert.areEqual (null, textFormat.font);
		Assert.areEqual (null, textFormat.size);
		
		var textFormat1 = new TextFormat ("_sans", 20, 0xFF0000);
		var textFormat2 = new TextFormat ("_serif", 40);
		
		textField.setTextFormat (textFormat1);
		
		Assert.isNotNull (textFormat);
		Assert.areEqual (null, textFormat.font);
		Assert.areEqual (null, textFormat.size);
		
		textField.text = "1234";
		textField.setTextFormat (textFormat1, 0, 4);
		textField.setTextFormat (textFormat2, 2, 4);
		
		var textFormat = textField.getTextFormat ();
		
		Assert.isNotNull (textFormat);
		Assert.areEqual (null, textFormat.font);
		Assert.areEqual (null, textFormat.size);
		Assert.areEqual (0xFF0000, textFormat.color);
		
		var textFormat = textField.getTextFormat (0, 2);
		
		Assert.isNotNull (textFormat);
		Assert.areEqual (textFormat1.font, textFormat.font);
		Assert.areEqual (textFormat1.size, textFormat.size);
		Assert.areEqual (textFormat1.color, textFormat.color);
		
		var textFormat = textField.getTextFormat (2, 4);
		
		Assert.isNotNull (textFormat);
		Assert.areEqual (textFormat2.font, textFormat.font);
		Assert.areEqual (textFormat2.size, textFormat.size);
		Assert.areEqual (textFormat1.color, textFormat.color);
		
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