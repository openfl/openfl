package;

import openfl.text.Font;
import utest.Assert;
import utest.Test;

class FontTest extends Test
{
	public function test_fontName()
	{
		// TODO: Confirm functionality

		var font = new Font();
		var exists = font.fontName;

		Assert.isNull(exists);
	}

	public function test_fontStyle()
	{
		// TODO: Confirm functionality

		var font = new Font();
		var exists = font.fontStyle;

		Assert.isNull(exists);
	}

	public function test_fontType()
	{
		// TODO: Confirm functionality

		var font = new Font();
		var exists = font.fontType;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var font = new Font();
		Assert.notNull(font);
	}

	public function test_enumerateFonts()
	{
		// TODO: Confirm functionality

		var exists = Font.enumerateFonts;

		Assert.notNull(exists);
	}

	public function test_registerFont()
	{
		// TODO: Confirm functionality

		var exists = Font.registerFont;

		Assert.notNull(exists);
	}
}
