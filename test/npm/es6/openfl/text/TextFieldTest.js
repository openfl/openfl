import BitmapData from "openfl/display/BitmapData";
import TextField from "openfl/text/TextField";
import TextFieldAutoSize from "openfl/text/TextFieldAutoSize";
import TextFieldType from "openfl/text/TextFieldType";
import * as assert from "assert";


describe ("ES6 | TextField", function () {
	
	
	var hex = function (value) {
		
		return (value >>> 0).toString (16).toUpperCase ();
		
	}
	
	
	it ("autoSize", function () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		assert.notEqual (textField.width, textField.textWidth + 4);
		
		textField.autoSize = TextFieldAutoSize.LEFT;
		
		assert.equal (textField.width, textField.textWidth + 4);
		
		textField.text = "H";
		
		assert.equal (textField.width, textField.textWidth + 4);
		
		textField.text = "Hello World";
		
		assert.equal (textField.width, textField.textWidth + 4);
		
	});
	
	
	it ("background", function () {
		
		var textField = new TextField ();
		
		assert (!textField.background);
		
		textField.background = true;
		
		assert (textField.background);
		
		var bitmapData = new BitmapData (textField.width, textField.height);
		bitmapData.draw (textField);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFFFFFF));
		
	});
	
	
	it ("backgroundColor", function () {
		
		var textField = new TextField ();
		
		assert.equal (hex (textField.backgroundColor), hex (0xFFFFFF));
		
		textField.backgroundColor = 0x00FF00;
		
		assert.equal (hex (textField.backgroundColor), hex (0x00FF00));
		
		var bitmapData = new BitmapData (textField.width, textField.height);
		bitmapData.draw (textField);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFFFFFF));
		
		textField.background = true;
		
		var bitmapData = new BitmapData (textField.width, textField.height);
		bitmapData.draw (textField);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFF00FF00));
		
	});
	
	
	it ("border", function () {
		
		var textField = new TextField ();
		
		assert (!textField.border);
		
		textField.border = true;
		
		assert (textField.border);
		
		var bitmapData = new BitmapData (textField.width, textField.height);
		bitmapData.draw (textField);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFF000000));
		
	});
	
	
	it ("borderColor", function () {
		
		var textField = new TextField ();
		
		assert.equal (hex (textField.borderColor), hex (0x000000));
		
		textField.borderColor = 0x00FF00;
		
		assert.equal (hex (textField.borderColor), hex (0x00FF00));
		
		var bitmapData = new BitmapData (textField.width, textField.height);
		bitmapData.draw (textField);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFFFFFFFF));
		
		textField.border = true;
		
		var bitmapData = new BitmapData (textField.width, textField.height);
		bitmapData.draw (textField);
		
		assert.equal (hex (bitmapData.getPixel32 (0, 0)), hex (0xFF00FF00));
		
	});
	
	
	it ("bottomScrollV", function () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		assert.equal (textField.bottomScrollV, 1);
		
		textField.text = "Hello\nWorld";
		
		assert.equal (textField.bottomScrollV, 2);
		
		textField.text = "";
		
		assert.equal (textField.bottomScrollV, 1);
		
	});
	
	
	it ("defaultTextFormat", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.defaultTextFormat;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("displayAsPassword", function () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		var textField2 = new TextField ();
		textField2.text = "Hello";
		textField2.displayAsPassword = true;
		
		var textField3 = new TextField ();
		textField3.text = "*****";
		
		// #if flash
		// // TODO -- textWidth is still unchanged?
		// assert.equal (textField.textWidth, textField2.textWidth);
		// assert.notEqual (textField3.textWidth, textField2.textWidth);
		// #end
		
		var bitmapData = new BitmapData (Math.ceil (textField.width), Math.ceil (textField.height), true);
		var bitmapData2 = bitmapData.clone ();
		var bitmapData3 = bitmapData.clone ();
		
		bitmapData.draw (textField);
		bitmapData2.draw (textField2);
		bitmapData3.draw (textField3);
		
		assert (bitmapData2.compare (bitmapData) instanceof BitmapData);
		assert.equal (bitmapData2.compare (bitmapData3), 0);
		
	});
	
	
	it ("embedFonts", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.embedFonts;
		
		assert (!exists);
		
	});
	
	
	it ("gridFitType", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.gridFitType;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("htmlText", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.htmlText;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("maxChars", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.maxChars;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("maxScrollH", function () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		assert.equal (textField.maxScrollH, 0);
		
	});
	
	
	it ("maxScrollV", function () {
		
		var textField = new TextField ();
		
		assert.equal (textField.maxScrollV, 1);
		
		textField.text = "Hello";
		
		assert.equal (textField.maxScrollV, 1);
		
		textField.text = "Hello\nWorld\n";
		
		assert.equal (textField.maxScrollV, 1);
		
		textField.multiline = true;
		
		assert.equal (textField.maxScrollV, 1);
		
		textField.text = "Hello\n\nWorld\n\nHello\n\nWorld\n\n";
		
		// #if !flash // sometimes 3, not 2?
		
		// #if !html5
		// //assert.equal (2, textField.maxScrollV);
		// assert (textField.maxScrollV == 2 || textField.maxScrollV == 3);
		// #end
		
		textField.height = 10;
		
		// #if flash
		// // should we replicate not updating until text is changed?
		// assert.equal (textField.maxScrollV, 2);
		// #end
		
		// #end
		
		textField.text = textField.text;
		
		// #if (!flash && !html5) // sometimes 10, not 9?
		
		// //assert.equal (9, textField.maxScrollV);
		// assert (textField.maxScrollV == 9 || textField.maxScrollV == 10);
		
		// #end
		
	});
	
	
	it ("multiline", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.multiline;
		
		assert (!exists);
		
	});
	
	
	it ("numLines", function () {
		
		var textField = new TextField ();
		textField.text = "Hello";
		
		assert.equal (textField.numLines, 1);
		
		textField.text = "Hello\nWorld";
		
		assert.equal (textField.numLines, 2);
		
		textField.text = "";
		
		assert.equal (textField.numLines, 1);
		
	});
	
	
	it ("scrollH", function () {
		
		var textField = new TextField ();
		
		assert.equal (textField.scrollH, 0);
		
		textField.text = "Hello";
		
		assert.equal (textField.scrollH, 0);
		
	});
	
	
	it ("scrollV", function () {
		
		var textField = new TextField ();
		
		assert.equal (textField.scrollV, 1);
		
		textField.text = "Hello";
		
		assert.equal (textField.scrollV, 1);
		
		textField.text = "Hello\nWorld";
		textField.height = 20;
		textField.multiline = true;
		
		// #if flash
		// textField.text = textField.text;
		// #end
		
		var textField2 = new TextField ();
		textField2.height = 20;
		textField2.text = "World";
		
		textField.scrollV = 2;
		
		var bitmapData = new BitmapData (Math.ceil (textField.width), Math.ceil (textField.height), true);
		var bitmapData2 = bitmapData.clone ();
		
		bitmapData.draw (textField);
		bitmapData2.draw (textField2);
		
		assert.equal (bitmapData.compare (bitmapData2), 0);
		
		textField.scrollV = 1000;
		
		assert.equal (textField.scrollV, textField.maxScrollV);
		
		var bitmapData = new BitmapData (Math.ceil (textField.width), Math.ceil (textField.height), true);
		bitmapData.draw (textField);
		
		assert.equal (bitmapData.compare (bitmapData2), 0);
		
	});
	
	
	it ("selectable", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.selectable;
		
		assert (exists);
		
	});
	
	
	it ("sharpness", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.sharpness;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("tabEnabled", function () {
		
		var textField = new TextField ();
		assert (!textField.tabEnabled);
		
		textField.type = TextFieldType.INPUT;
		assert (textField.tabEnabled);
		
		textField.tabEnabled = false;
		assert (!textField.tabEnabled);
		
		textField.type = TextFieldType.DYNAMIC;
		textField.type = TextFieldType.INPUT;
		assert (!textField.tabEnabled);
		
		textField.type = TextFieldType.DYNAMIC;
		textField.tabEnabled = true;
		assert (textField.tabEnabled);
		
	});
	
	
	it ("text", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.text;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("textColor", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textColor;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("textHeight", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textHeight;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("textWidth", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.textWidth;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("type", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.type;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("wordWrap", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.wordWrap;
		
		assert (!exists);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		assert.notEqual (textField, null);
		
	});
	
	
	it ("appendText", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.appendText;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getLineMetrics", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineMetrics;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getLineOffset", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineOffset;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getLineText", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getLineText;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getTextFormat", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.getTextFormat;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setSelection", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.setSelection;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setTextFormat", function () {
		
		// TODO: Confirm functionality
		
		var textField = new TextField ();
		var exists = textField.setTextFormat;
		
		assert.notEqual (exists, null);
		
	});
	
	
});