import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

class TextFieldTest
{
	public static function __init__()
	{
		Mocha.describe("TextField", function()
		{
			Mocha.it("autoSize", function()
			{
				var textField = new TextField();
				textField.text = "Hello";

				Assert.notEqual(textField.width, textField.textWidth + 4);

				textField.autoSize = TextFieldAutoSize.LEFT;

				Assert.equal(textField.width, textField.textWidth + 4);

				textField.text = "H";

				Assert.equal(textField.width, textField.textWidth + 4);

				textField.text = "Hello World";

				Assert.equal(textField.width, textField.textWidth + 4);
			});

			Mocha.it("background", function()
			{
				var textField = new TextField();

				Assert.assert(!textField.background);

				textField.background = true;

				Assert.assert(textField.background);

				var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
				bitmapData.draw(textField);

				Assert.equal(StringTools.hex(bitmapData.getPixel32(0, 0), 8), StringTools.hex(0xFFFFFFFF, 8));
			});

			Mocha.it("backgroundColor", function()
			{
				var textField = new TextField();

				Assert.equal(StringTools.hex(textField.backgroundColor, 6), StringTools.hex(0xFFFFFF, 6));

				textField.backgroundColor = 0x00FF00;

				Assert.equal(StringTools.hex(textField.backgroundColor, 6), StringTools.hex(0x00FF00, 6));

				var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
				bitmapData.draw(textField);

				Assert.equal(StringTools.hex(bitmapData.getPixel32(0, 0), 8), StringTools.hex(0xFFFFFFFF, 8));

				textField.background = true;

				var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
				bitmapData.draw(textField);

				Assert.equal(StringTools.hex(bitmapData.getPixel32(0, 0), 8), StringTools.hex(0xFF00FF00, 8));
			});

			Mocha.it("border", function()
			{
				var textField = new TextField();

				Assert.assert(!textField.border);

				textField.border = true;

				Assert.assert(textField.border);

				var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
				bitmapData.draw(textField);

				Assert.equal(StringTools.hex(bitmapData.getPixel32(0, 0), 8), StringTools.hex(0xFF000000, 8));
			});

			Mocha.it("borderColor", function()
			{
				var textField = new TextField();

				Assert.equal(StringTools.hex(textField.borderColor, 6), StringTools.hex(0x000000, 6));

				textField.borderColor = 0x00FF00;

				Assert.equal(StringTools.hex(textField.borderColor, 6), StringTools.hex(0x00FF00, 6));

				var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
				bitmapData.draw(textField);

				Assert.equal(StringTools.hex(bitmapData.getPixel32(0, 0), 8), StringTools.hex(0xFFFFFFFF, 8));

				textField.border = true;

				var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
				bitmapData.draw(textField);

				Assert.equal(StringTools.hex(bitmapData.getPixel32(0, 0), 8), StringTools.hex(0xFF00FF00, 8));
			});

			Mocha.it("bottomScrollV", function()
			{
				var textField = new TextField();
				textField.text = "Hello";

				Assert.equal(textField.bottomScrollV, 1);

				textField.text = "Hello\nWorld";

				Assert.equal(textField.bottomScrollV, 2);

				textField.text = "";

				Assert.equal(textField.bottomScrollV, 1);
				
				textField.height = 40;
				textField.text = "Test\nTest\nTest\nTest\nTest";
				textField.scrollV = 3;
				
				Assert.equal(textField.bottomScrollV, 4);
			});

			Mocha.it("defaultTextFormat", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.defaultTextFormat;

				Assert.notEqual(exists, null);
			});

			Mocha.it("displayAsPassword", function()
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
				Assert.equal(textField.textWidth, textField2.textWidth);
				Assert.notEqual(textField3.textWidth, textField2.textWidth);
				#end

				var bitmapData = new BitmapData(Math.ceil(textField.width), Math.ceil(textField.height), true);
				var bitmapData2 = bitmapData.clone();
				var bitmapData3 = bitmapData.clone();

				bitmapData.draw(textField);
				bitmapData2.draw(textField2);
				bitmapData3.draw(textField3);

				Assert.assert(Std.is(bitmapData2.compare(bitmapData), BitmapData));
				Assert.equal(bitmapData2.compare(bitmapData3), 0);
			});

			Mocha.it("embedFonts", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.embedFonts;

				Assert.assert(!exists);
			});

			Mocha.it("gridFitType", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.gridFitType;

				Assert.notEqual(exists, null);
			});

			Mocha.it("htmlText", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.htmlText;

				Assert.notEqual(exists, null);
				
				textField.htmlText = "<b>text</b>";
				
				Assert.equal(textField.caretIndex, 4);
			});

			Mocha.it("maxChars", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.maxChars;

				Assert.notEqual(exists, null);
			});

			Mocha.it("maxScrollH", function()
			{
				var textField = new TextField();
				textField.text = "Hello";

				Assert.equal(textField.maxScrollH, 0);
				
				text.scrollH = text.maxScrollH + 24;
				Assert.equal(textField.scrollH, textField.maxScrollH);
			});

			Mocha.it("maxScrollV", function()
			{
				var textField = new TextField();
				textField.height = 20;
				
				Assert.equal(textField.maxScrollV, 1);

				textField.text = "Hello";

				Assert.equal(textField.maxScrollV, 1);

				textField.text = "Hello\nWorld\n";

				Assert.equal(textField.maxScrollV, 3);

				textField.text = "Hello\n\nWorld\n\nHello\n\nWorld\n\n";
				
				Assert.equal(textField.maxScrollV, 9);
			});

			Mocha.it("multiline", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.multiline;

				Assert.assert(!exists);
			});

			Mocha.it("numLines", function()
			{
				var textField = new TextField();
				textField.text = "Hello";

				Assert.equal(textField.numLines, 1);

				textField.text = "Hello\nWorld";

				Assert.equal(textField.numLines, 2);

				textField.text = "Hello\nWorld\n\n";

				Assert.equal(textField.numLines, 4);

				textField.text = "";

				Assert.equal(textField.numLines, 1);
			});

			Mocha.it("scrollH", function()
			{
				var textField = new TextField();

				Assert.equal(textField.scrollH, 0);

				textField.text = "Hello";

				Assert.equal(textField.scrollH, 0);
			});

			Mocha.it("scrollV", function()
			{
				var textField = new TextField();

				Assert.equal(textField.scrollV, 1);

				textField.text = "Hello";

				Assert.equal(textField.scrollV, 1);

				textField.text = "Hello\nWorld";
				textField.height = 20;

				#if flash
				textField.text = textField.text;
				#end

				var textField2 = new TextField();
				textField2.height = 20;
				textField2.text = "World";

				textField.scrollV = 2;

				var bitmapData = new BitmapData(Math.ceil(textField.width), Math.ceil(textField.height), true);
				var bitmapData2 = bitmapData.clone();

				bitmapData.draw(textField);
				bitmapData2.draw(textField2);

				Assert.equal(bitmapData.compare(bitmapData2), 0);

				textField.scrollV = 1000;

				Assert.equal(textField.scrollV, textField.maxScrollV);

				var bitmapData = new BitmapData(Math.ceil(textField.width), Math.ceil(textField.height), true);
				bitmapData.draw(textField);

				Assert.equal(bitmapData.compare(bitmapData2), 0);
			});

			Mocha.it("selectable", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.selectable;

				Assert.assert(exists);
			});

			Mocha.it("sharpness", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.sharpness;

				Assert.notEqual(exists, null);
			});

			Mocha.it("tabEnabled", function()
			{
				var textField = new TextField();
				Assert.assert(!textField.tabEnabled);

				textField.type = INPUT;
				Assert.assert(textField.tabEnabled);

				textField.tabEnabled = false;
				Assert.assert(!textField.tabEnabled);

				textField.type = DYNAMIC;
				textField.type = INPUT;
				Assert.assert(!textField.tabEnabled);

				textField.type = DYNAMIC;
				textField.tabEnabled = true;
				Assert.assert(textField.tabEnabled);
			});

			Mocha.it("text", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.text;

				Assert.notEqual(exists, null);
				
				textField.text = "Test\nText";
				
				Assert.equal(textField.caretIndex, 0);
			});

			Mocha.it("textColor", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.textColor;

				Assert.notEqual(exists, null);
			});

			Mocha.it("textHeight", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.textHeight;

				Assert.notEqual(exists, null);
			});

			Mocha.it("textWidth", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.textWidth;

				Assert.notEqual(exists, null);
			});

			Mocha.it("type", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.type;

				Assert.notEqual(exists, null);
			});

			Mocha.it("wordWrap", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.wordWrap;

				Assert.assert(!exists);
			});

			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				Assert.notEqual(textField, null);
			});

			Mocha.it("appendText", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.appendText;

				Assert.notEqual(exists, null);
				
				textField.appendText("test");
				
				Assert.equal(textField.caretIndex, 4);
			});

			Mocha.it("getLineMetrics", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.getLineMetrics;

				Assert.notEqual(exists, null);
			});

			Mocha.it("getLineOffset", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.getLineOffset;

				Assert.notEqual(exists, null);
			});

			Mocha.it("getLineText", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.getLineText;

				Assert.notEqual(exists, null);
			});

			Mocha.it("getTextFormat", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.getTextFormat;

				Assert.notEqual(exists, null);
			});

			Mocha.it("setSelection", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.setSelection;

				Assert.notEqual(exists, null);
			});

			Mocha.it("setTextFormat", function()
			{
				// TODO: Confirm functionality

				var textField = new TextField();
				var exists = textField.setTextFormat;

				Assert.notEqual(exists, null);
				
				// test out of bounds
				textField.text = "testing setTextFormat";
				
				var format = new openfl.text.TextFormat();
				
				// add tests for weird -1 cases that don't actually error
				Assert.doesNotThrow(() -> { textField.setTextFormat(format, -1, -1); }, openfl.errors.RangeError);
				Assert.doesNotThrow(() -> { textField.setTextFormat(format, 3, -1); }, openfl.errors.RangeError);
				Assert.throws(() -> { textField.setTextFormat(format, -2, 5); }, openfl.errors.RangeError);
				Assert.throws(() -> { textField.setTextFormat(format, -1, 0); }, openfl.errors.RangeError);
				Assert.throws(() -> { textField.setTextFormat(format, 2, 1); }, openfl.errors.RangeError);
				// Assert.throws(() -> { textField.setTextFormat(format, 21, 21); }, openfl.errors.RangeError); // confirm
				Assert.throws(() -> { textField.setTextFormat(format, 21, 23); }, openfl.errors.RangeError);
				Assert.throws(() -> { textField.setTextFormat(format, 1, 25); }, openfl.errors.RangeError);
				
				// for each case, including begin==end, compare format ranges with known values
				// don't go into textengine, use gettextformat and getCharBoundaries to see what's going on
				
				textField.setTextFormat(new TextFormat(12), -1, -1); // baseline
				textField.setTextFormat(new TextFormat(16), 0, 5); // test overwrite beginning
				textField.setTextFormat(new TextFormat(16), 10, 12);
				textField.setTextFormat(new TextFormat(16), 15, 21);
				textField.setTextFormat(new TextFormat(20), 3, 18);
				textField.setTextFormat(new TextFormat(18), 9, 13);
				Assert.equal(textField.getTextFormat(1, 2).size, 16);
				Assert.equal(textField.getTextFormat(4, 5).size, 20);
				Assert.equal(textField.getTextFormat(15, 16).size, 20);
				Assert.equal(textField.getTextFormat(11, 12).size, 18);
				Assert.equal(textField.getTextFormat(20, 21).size, 16);
				textField.setTextFormat(new TextFormat(14), -1, -1); // test overwriting entire range
				Assert.equal(textField.getTextFormat(11, 12).size, 14);
				
				textField.setTextFormat(new TextFormat(12), -1, -1);
				textField.setTextFormat(new TextFormat(14), 0, 3);
				textField.setTextFormat(new TextFormat(16), 0, 4); // test overwriting existing ranges
				Assert.equal(textField.getTextFormat(7, 8).size, 12); // the failure is too janky to fully capture
				
				textField.setTextFormat(textField.defaultTextFormat, -1, -1);
				textField.setTextFormat(new TextFormat(14), -1, -1);
				Assert.equal(textField.defaultTextFormat.size, 12); // defaultTextFormat should not be overwritten by setTextFormat
				
				textField.text = "test test test test\ntest test";
				textField.width = 180;
				textField.height = 300;
				textField.wordWrap = true;
				
				var lmargin = 50;
				var rmargin = 50;
				var indent = 25;
				var bindent = 25;
				var format = new TextFormat(null, null, null, null, null, null, null, null, null, lmargin, 0, indent);
				format.blockIndent = bindent;
				textField.setTextFormat(format, -1, -1);
				format = new TextFormat(null, null, null, null, null, null, null, null, RIGHT, 0, rmargin);
				textField.setTextFormat(format, 19, textField.text.length);
				Assert.equal(textField.getCharBoundaries(0).x, lmargin + indent + bindent + 2); // test leftMargin, indent, blockIndent
				Assert.equal(textField.getCharBoundaries(10).x, lmargin + bindent + 2); // test indent doesn't affect subsequent lines
				var charb = textField.getCharBoundaries(textField.text.length - 1);
				Assert.equal(charb.x + charb.width, textField.width - 2 - rmargin); // test rightMargin
			});
		});
	}
}
