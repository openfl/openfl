package;

import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import utest.Assert;
import utest.Test;

class TextFormatTest extends Test
{
	public function test_new_()
	{
		var format:TextFormat = new TextFormat();

		Assert.isNull(format.font);
		Assert.isNull(format.size);
		Assert.isNull(format.color);
		Assert.isNull(format.bold);
		Assert.isNull(format.italic);
		Assert.isNull(format.underline);
		Assert.isNull(format.url);
		Assert.isNull(format.target);
		Assert.isNull(format.align);
		Assert.isNull(format.leftMargin);
		Assert.isNull(format.rightMargin);
		Assert.isNull(format.indent);
		Assert.isNull(format.leading);
		Assert.isNull(format.blockIndent);
		Assert.isNull(format.bullet);
		Assert.isNull(format.kerning);
		Assert.isNull(format.letterSpacing);
		#if !flash
		Assert.isNull(format.strikethrough);
		#end
		Assert.isNull(format.tabStops);

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
		Assert.isNull(format.blockIndent);
		Assert.isNull(format.bullet);
		Assert.isNull(format.kerning);
		Assert.isNull(format.letterSpacing);
		#if !flash
		Assert.isNull(format.strikethrough);
		#end
		Assert.isNull(format.tabStops);
	}

	public function test_align()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.align);
	}

	public function test_blockIndent()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.blockIndent);
	}

	public function test_bold()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.bold);
	}

	public function test_bullet()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.bullet);
	}

	public function test_color()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.color);
	}

	public function test_font()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.font);
	}

	public function test_indent()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.indent);
	}

	public function test_italic()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.italic);
	}

	public function test_kerning()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.kerning);
	}

	public function test_leading()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.leading);
	}

	public function test_leftMargin()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.leftMargin);
	}

	public function test_letterSpacing()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.letterSpacing);
	}

	public function test_rightMargin()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.rightMargin);
	}

	public function test_size()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.size);
	}

	public function test_tabStops()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.tabStops);
	}

	public function test_target()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.target);
	}

	public function test_underline()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.underline);
	}

	public function test_url()
	{
		var textFormat = new TextFormat();
		Assert.isNull(textFormat.url);
	}
}
