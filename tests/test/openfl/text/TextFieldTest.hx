package openfl.text;


import massive.munit.Assert;
import openfl.display.BitmapData;


class TextFieldTest {
	
	
	@Test public function autoSize () {
		
		#if neko
		Sys.println ("autoSize");
		#end
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		#if !openfl_legacy
		
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
		
		#if neko
		Sys.println ("background");
		#end
		
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
		
		#if neko
		Sys.println ("backgroundColor");
		#end
		
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
		#if (flash || openfl_legacy)
		Assert.isTrue ((StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFF00FF00, 8)) || (StringTools.hex (bitmapData.getPixel32 (0, 0), 8) == StringTools.hex (0xFE00FF00, 8)));
		#end
		//Assert.areEqual (StringTools.hex (0xFF00FF00, 8), StringTools.hex (bitmapData.getPixel32 (0, 0), 8));
		
	}
	
	
	@Test public function border () {
		
		#if neko
		Sys.println ("border");
		#end
		
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
		
		#if neko
		Sys.println ("borderColor");
		#end
		
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
		
		#if neko
		Sys.println ("bottomScrollV");
		#end
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		Assert.areEqual (1, textField.bottomScrollV);
		
		textField.text = "Hello\nWorld";
		
		Assert.areEqual (2, textField.bottomScrollV);
		
		textField.text = "";
		
		Assert.areEqual (1, textField.bottomScrollV);
		
	}
	
	
	@Test public function defaultTextFormat () {
		
		#if neko
		Sys.println ("defaultTextFormat");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.defaultTextFormat;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function displayAsPassword () {
		
		#if neko
		Sys.println ("displayAsPassword");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.displayAsPassword;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function embedFonts () {
		
		#if neko
		Sys.println ("embedFonts");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.embedFonts;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function gridFitType () {
		
		#if neko
		Sys.println ("gridFitType");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.gridFitType;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function htmlText () {
		
		#if neko
		Sys.println ("htmlText");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.htmlText;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function maxChars () {
		
		#if neko
		Sys.println ("maxChars");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.maxChars;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function maxScrollH () {
		
		#if neko
		Sys.println ("maxScrollH");
		#end
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		Assert.areEqual (0, textField.maxScrollH);
		
	}
	
	
	@Test public function maxScrollV () {
		
		#if neko
		Sys.println ("maxScrollV");
		#end
		
		var textField = new TextField ();
		
		Assert.areEqual (1, textField.maxScrollV);
		
		textField.text = "Hello";
		
		Assert.areEqual (1, textField.maxScrollV);
		
		textField.text = "Hello\nWorld\n";
		
		Assert.areEqual (1, textField.maxScrollV);
		
	}
	
	
	@Test public function multiline () {
		
		#if neko
		Sys.println ("multiline");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.multiline;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function numLines () {
		
		#if neko
		Sys.println ("numLines");
		#end
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		Assert.areEqual (1, textField.numLines);
		
		textField.text = "Hello\nWorld";
		
		Assert.areEqual (2, textField.numLines);
		
		textField.text = "";
		
		Assert.areEqual (1, textField.numLines);
		
	}
	
	
	@Test public function scrollH () {
		
		#if neko
		Sys.println ("scrollH");
		#end
		
		var textField = new TextField ();
		
		Assert.areEqual (0, textField.scrollH);
		
		textField.text = "Hello";
		
		Assert.areEqual (0, textField.scrollH);
		
	}
	
	
	@Test public function scrollV () {
		
		#if neko
		Sys.println ("scrollV");
		#end
		
		var textField = new TextField ();
		
		Assert.areEqual (1, textField.scrollV);
		
		textField.text = "Hello";
		
		Assert.areEqual (1, textField.scrollV);
		
	}
	
	
	@Test public function selectable () {
		
		#if neko
		Sys.println ("selectable");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.selectable;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function sharpness () {
		
		#if neko
		Sys.println ("sharpness");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.sharpness;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function text () {
		
		#if neko
		Sys.println ("text");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.text;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function textColor () {
		
		#if neko
		Sys.println ("textColor");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textColor;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function textHeight () {
		
		#if neko
		Sys.println ("textHeight");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textHeight;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function textWidth () {
		
		#if neko
		Sys.println ("textWidth");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textWidth;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function type () {
		
		#if neko
		Sys.println ("type");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.type;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function wordWrap () {
		
		#if neko
		Sys.println ("wordWrap");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.wordWrap;
		
		Assert.isFalse (exists);
		
	}
	
	
	@Test public function new_ () {
		
		#if neko
		Sys.println ("new");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		Assert.isNotNull (textField);
		
	}
	
	
	@Test public function appendText () {
		
		#if neko
		Sys.println ("appendText");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.appendText;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getLineMetrics () {
		
		#if neko
		Sys.println ("getLineMetrics");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineMetrics;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getLineOffset () {
		
		#if neko
		Sys.println ("getLineOffset");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineOffset;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getLineText () {
		
		#if neko
		Sys.println ("getLineText");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineText;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getTextFormat () {
		
		#if neko
		Sys.println ("getTextFormat");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getTextFormat;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setSelection () {
		
		#if neko
		Sys.println ("setSelection");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.setSelection;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setTextFormat () {
		
		#if neko
		Sys.println ("setTextFormat");
		#end
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.setTextFormat;
		
		Assert.isNotNull (exists);
		
	}
	
	
}