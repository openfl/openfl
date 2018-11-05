package openfl.text;


import massive.munit.Assert;


class TextFormatTest {
    @Test public function _new() {
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

        var format:TextFormat = new TextFormat(
        font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading
        );

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

    @Test public function clone() {
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

        var format:TextFormat = new TextFormat(
        font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading
        );

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

        var format_clone:TextFormat = format.clone();

        Assert.areNotEqual(format, format_clone);

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

        Assert.areEqual(font, format_clone.font);
        Assert.areEqual(size, format_clone.size);
        Assert.areEqual(color, format_clone.color);
        Assert.areEqual(bold, format_clone.bold);
        Assert.areEqual(italic, format_clone.italic);
        Assert.areEqual(underline, format_clone.underline);
        Assert.areEqual(url, format_clone.url);
        Assert.areEqual(target, format_clone.target);
        Assert.areEqual(align, format_clone.align);
        Assert.areEqual(leftMargin, format_clone.leftMargin);
        Assert.areEqual(rightMargin, format_clone.rightMargin);
        Assert.areEqual(indent, format_clone.indent);
        Assert.areEqual(leading, format_clone.leading);

        format_clone.font = 'Text Font Cloned';
        format_clone.size = 321;
        format_clone.color = 0x00FF00;
        format_clone.bold = false;
        format_clone.italic = true;
        format_clone.underline = false;
        format_clone.url = 'Text URL Cloned';
        format_clone.target = 'Target Cloned';
        format_clone.align = TextFormatAlign.LEFT;
        format_clone.leftMargin = 5;
        format_clone.rightMargin = 10;
        format_clone.indent = 6;
        format_clone.leading = 14;

        Assert.areNotEqual(font, format_clone.font);
        Assert.areNotEqual(size, format_clone.size);
        Assert.areNotEqual(color, format_clone.color);
        Assert.areNotEqual(bold, format_clone.bold);
        Assert.areNotEqual(italic, format_clone.italic);
        Assert.areNotEqual(underline, format_clone.underline);
        Assert.areNotEqual(url, format_clone.url);
        Assert.areNotEqual(target, format_clone.target);
        Assert.areNotEqual(align, format_clone.align);
        Assert.areNotEqual(leftMargin, format_clone.leftMargin);
        Assert.areNotEqual(rightMargin, format_clone.rightMargin);
        Assert.areNotEqual(indent, format_clone.indent);
        Assert.areNotEqual(leading, format_clone.leading);

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

	@Test public function align () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.align;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function blockIndent () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.blockIndent;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function bold () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.bold;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function bullet () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.bullet;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function color () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.color;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function font () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.font;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function indent () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.indent;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function italic () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.italic;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function kerning () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.kerning;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function leading () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.leading;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function leftMargin () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.leftMargin;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function letterSpacing () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.letterSpacing;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function rightMargin () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.rightMargin;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function size () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.size;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function tabStops () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.tabStops;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function target () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.target;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function underline () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.underline;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function url () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		var exists = textFormat.url;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var textFormat = new TextFormat ();
		Assert.isNotNull (textFormat);
		
	}
	
	
}