package;

import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import utest.Assert;
import utest.Test;

class TextFormatTest extends Test
{
	public function test__new()
	{
		var font:String = 'Text Font';
		var size:Int = 123;
		var color:Int = 0xFF00FF;
		var bold:Bool = true;
		var italic:Bool = false;
		var underline:Bool = true;
		var url:String = 'Text URL';
		var target:String = 'Target';
		var align:TextFormatAlign = TextFormatAlign.CENTER;
		var leftMargin:Int = 10;
		var rightMargin:Int = 5;
		var indent:Int = 3;
		var leading:Int = 7;

		var format:TextFormat = new TextFormat(font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);

		Assert.equals(font, format.font);
		Assert.equals(size, format.size);
		Assert.equals(color, format.color);
		Assert.equals(bold, format.bold);
		Assert.equals(italic, format.italic);
		Assert.equals(underline, format.underline);
		Assert.equals(url, format.url);
		Assert.equals(target, format.target);
		Assert.equals(align, format.align);
		Assert.equals(leftMargin, format.leftMargin);
		Assert.equals(rightMargin, format.rightMargin);
		Assert.equals(indent, format.indent);
		Assert.equals(leading, format.leading);
	}

	public function test_align()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.align;

		Assert.isNull(exists);
	}

	public function test_blockIndent()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.blockIndent;

		Assert.isNull(exists);
	}

	public function test_bold()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.bold;

		Assert.isNull(exists);
	}

	public function test_bullet()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.bullet;

		Assert.isNull(exists);
	}

	public function test_color()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.color;

		Assert.isNull(exists);
	}

	public function test_font()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.font;

		Assert.isNull(exists);
	}

	public function test_indent()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.indent;

		Assert.isNull(exists);
	}

	public function test_italic()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.italic;

		Assert.isNull(exists);
	}

	public function test_kerning()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.kerning;

		Assert.isNull(exists);
	}

	public function test_leading()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.leading;

		Assert.isNull(exists);
	}

	public function test_leftMargin()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.leftMargin;

		Assert.isNull(exists);
	}

	public function test_letterSpacing()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.letterSpacing;

		Assert.isNull(exists);
	}

	public function test_rightMargin()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.rightMargin;

		Assert.isNull(exists);
	}

	public function test_size()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.size;

		Assert.isNull(exists);
	}

	public function test_tabStops()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.tabStops;

		Assert.isNull(exists);
	}

	public function test_target()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.target;

		Assert.isNull(exists);
	}

	public function test_underline()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.underline;

		Assert.isNull(exists);
	}

	public function test_url()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.url;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		Assert.notNull(textFormat);
	}
}
