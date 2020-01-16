package text;

import openfl.display.BitmapData;
import openfl.text.TextField;

class TextFieldRenderTest
{
	@Test public function background()
	{
		var textField = new TextField();
		textField.background = true;

		var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
		bitmapData.draw(textField);

		Assert.areEqual(StringTools.hex(0xFFFFFFFF, 8), StringTools.hex(bitmapData.getPixel32(0, 0), 8));
	}

	@Test public function backgroundColor()
	{
		var textField = new TextField();
		textField.backgroundColor = 0x00FF00;

		var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
		bitmapData.draw(textField);

		Assert.areEqual(StringTools.hex(0xFFFFFFFF, 8), StringTools.hex(bitmapData.getPixel32(0, 0), 8));

		textField.background = true;

		var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
		bitmapData.draw(textField);

		Assert.areEqual(StringTools.hex(0xFF00FF00, 8), StringTools.hex(bitmapData.getPixel32(0, 0), 8));
	}

	@Test public function border()
	{
		var textField = new TextField();
		textField.border = true;

		var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
		bitmapData.draw(textField);

		Assert.areEqual(StringTools.hex(0xFF000000, 8), StringTools.hex(bitmapData.getPixel32(0, 0), 8));
	}

	@Test public function borderColor()
	{
		var textField = new TextField();
		textField.borderColor = 0x00FF00;

		var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
		bitmapData.draw(textField);

		Assert.areEqual(StringTools.hex(0xFFFFFFFF, 8), StringTools.hex(bitmapData.getPixel32(0, 0), 8));

		textField.border = true;

		var bitmapData = new BitmapData(Std.int(textField.width), Std.int(textField.height));
		bitmapData.draw(textField);

		Assert.areEqual(StringTools.hex(0xFF00FF00, 8), StringTools.hex(bitmapData.getPixel32(0, 0), 8));
	}

	@Test public function displayAsPassword()
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
		Assert.areEqual(textField.textWidth, textField2.textWidth);
		Assert.areNotEqual(textField3.textWidth, textField2.textWidth);
		#end

		var bitmapData = new BitmapData(Math.ceil(textField.width), Math.ceil(textField.height), true);
		var bitmapData2 = bitmapData.clone();
		var bitmapData3 = bitmapData.clone();

		bitmapData.draw(textField);
		bitmapData2.draw(textField2);
		bitmapData3.draw(textField3);

		Assert.isTrue(Std.is(bitmapData2.compare(bitmapData), BitmapData));
		Assert.areEqual(0, bitmapData2.compare(bitmapData3));
	}

	@Test public function scrollV()
	{
		var textField = new TextField();

		Assert.areEqual(1, textField.scrollV);

		textField.text = "Hello";

		Assert.areEqual(1, textField.scrollV);

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

		var bitmapData = new BitmapData(Math.ceil(textField.width), Math.ceil(textField.height), true);
		var bitmapData2 = bitmapData.clone();

		bitmapData.draw(textField);
		bitmapData2.draw(textField2);

		Assert.areEqual(0, bitmapData.compare(bitmapData2));

		textField.scrollV = 1000;

		Assert.areEqual(textField.maxScrollV, textField.scrollV);

		var bitmapData = new BitmapData(Math.ceil(textField.width), Math.ceil(textField.height), true);
		bitmapData.draw(textField);

		Assert.areEqual(0, bitmapData.compare(bitmapData2));
	}
}
