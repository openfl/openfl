package openfl.text;

import massive.munit.Assert;

class TextFormatTest
{
	@Test public function _new()
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

		Assert.areEqual(font, format.font);
		Assert.areEqual(size, format.size);
		Assert.areEqual(color, format.color);
		Assert.areEqual(bold, format.bold);
		Assert.areEqual(italic, format.italic);
		Assert.areEqual(underline, format.underline);
		Assert.areEqual(url, format.url);
		Assert.areEqual(target, format.target);
		Assert.areEqual(align, format.align);
		Assert.areEqual(leftMargin, format.leftMargin);
		Assert.areEqual(rightMargin, format.rightMargin);
		Assert.areEqual(indent, format.indent);
		Assert.areEqual(leading, format.leading);
	}

	@Test public function align()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.align;

		Assert.isNull(exists);
	}

	@Test public function blockIndent()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.blockIndent;

		Assert.isNull(exists);
	}

	@Test public function bold()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.bold;

		Assert.isNull(exists);
	}

	@Test public function bullet()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.bullet;

		Assert.isNull(exists);
	}

	@Test public function color()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.color;

		Assert.isNull(exists);
	}

	@Test public function font()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.font;

		Assert.isNull(exists);
	}

	@Test public function indent()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.indent;

		Assert.isNull(exists);
	}

	@Test public function italic()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.italic;

		Assert.isNull(exists);
	}

	@Test public function kerning()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.kerning;

		Assert.isNull(exists);
	}

	@Test public function leading()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.leading;

		Assert.isNull(exists);
	}

	@Test public function leftMargin()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.leftMargin;

		Assert.isNull(exists);
	}

	@Test public function letterSpacing()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.letterSpacing;

		Assert.isNull(exists);
	}

	@Test public function rightMargin()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.rightMargin;

		Assert.isNull(exists);
	}

	@Test public function size()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.size;

		Assert.isNull(exists);
	}

	@Test public function tabStops()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.tabStops;

		Assert.isNull(exists);
	}

	@Test public function target()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.target;

		Assert.isNull(exists);
	}

	@Test public function underline()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.underline;

		Assert.isNull(exists);
	}

	@Test public function url()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		var exists = textFormat.url;

		Assert.isNull(exists);
	}

	@Test public function new_()
	{
		// TODO: Confirm functionality

		var textFormat = new TextFormat();
		Assert.isNotNull(textFormat);
	}
}
