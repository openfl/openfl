package openfl._internal.formats.animate;

#if lime
import lime.utils.Log;
#end
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.formats.animate.AnimateLibrary)
@:access(openfl.text.TextField)
@:access(openfl.text.TextFormat)
class AnimateDynamicTextSymbol extends AnimateSymbol
{
	public var align: /*TextFormatAlign*/ String;
	public var border:Bool;
	public var color:Null<Int>;
	public var fontHeight:Int;
	public var fontID:Int;
	public var fontName:String;
	public var height:Float;
	public var html:Bool;
	public var indent:Null<Int>;
	public var input:Bool;
	public var leading:Null<Int>;
	public var leftMargin:Null<Int>;
	public var multiline:Bool;
	public var password:Bool;
	public var rightMargin:Null<Int>;
	public var selectable:Bool;
	public var text:String;
	public var width:Float;
	public var wordWrap:Bool;
	public var x:Float;
	public var y:Float;

	public function new()
	{
		super();
	}

	private override function __createObject(library:AnimateLibrary):TextField
	{
		var textField = new TextField();

		// #if !flash
		// textField.__symbol = this;
		// #end

		textField.width = width;
		textField.height = height;

		#if !flash
		textField.__offsetX = x;
		textField.__offsetY = y;
		#end

		textField.multiline = multiline;
		textField.wordWrap = wordWrap;
		textField.displayAsPassword = password;

		if (border)
		{
			textField.border = true;
			textField.background = true;
		}

		textField.selectable = selectable;

		if (input)
		{
			textField.type = INPUT;
		}

		var format = new TextFormat();
		if (color != null) format.color = (color & 0x00FFFFFF);
		format.size = Math.round(fontHeight / 20);

		var font:AnimateFontSymbol = cast library.symbols.get(fontID);

		if (font != null)
		{
			// TODO: Bold and italic are handled in the font already
			// Setting this can cause "extra" bold in HTML5

			// format.bold = font.bold;
			// format.italic = font.italic;
			// format.leading = Std.int (font.leading / 20 + (format.size * 0.2) #if flash + 2 #end);
			// embedFonts = true;

			#if !flash
			format.__ascent = ((font.ascent / 20) / 1024);
			format.__descent = ((font.descent / 20) / 1024);
			#end
		}

		format.font = fontName;

		var found = false;

		switch (format.font)
		{
			case "_sans", "_serif", "_typewriter", "", null:
				found = true;

			default:
				for (font in Font.enumerateFonts())
				{
					if (font.fontName == format.font)
					{
						found = true;
						break;
					}
				}
		}

		if (!found)
		{
			var alpha = ~/[^a-zA-Z]+/g;

			for (font in Font.enumerateFonts())
			{
				if (alpha.replace(font.fontName, "").substr(0, fontName.length) == fontName)
				{
					format.font = font.fontName;
					found = true;
					break;
				}
			}
		}

		if (found)
		{
			textField.embedFonts = true;
		}
		#if (lime && !flash)
		else if (!TextField.__missingFontWarning.exists(format.font))
		{
			TextField.__missingFontWarning[format.font] = true;
			Log.warn("Could not find required font \"" + format.font + "\", it has not been embedded");
		}
		#end

		if (align != null)
		{
			if (align == "center") format.align = TextFormatAlign.CENTER;
			else if (align == "right") format.align = TextFormatAlign.RIGHT;
			else if (align == "justify") format.align = TextFormatAlign.JUSTIFY;

			format.leftMargin = Std.int(leftMargin / 20);
			format.rightMargin = Std.int(rightMargin / 20);
			format.indent = Std.int(indent / 20);
			format.leading = Std.int(leading / 20);
		}

		textField.defaultTextFormat = format;

		if (text != null)
		{
			if (html)
			{
				textField.htmlText = text;
			}
			else
			{
				textField.text = text;
			}
		}

		// textField.autoSize = (tag.autoSize) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
		return textField;
	}
}
