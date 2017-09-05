package format.swf.lite;


import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.geom.Point;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import format.swf.lite.symbols.DynamicTextSymbol;
import format.swf.lite.symbols.FontSymbol;
import format.swf.lite.SWFLite;


class DynamicTextField extends TextField {


	public var symbol:DynamicTextSymbol;

	private var glyphs:Array<Shape>;
	private var swf:SWFLite;
	private var _text:String;
	private var _variableName:String;

	public function new (swf:SWFLite, symbol:DynamicTextSymbol) {

		super ();

		this.swf = swf;
		this.symbol = symbol;

		_variableName = symbol.variableName;

		width = symbol.width;
		height = symbol.height;

		multiline = symbol.multiline;
		wordWrap = symbol.wordWrap;
		displayAsPassword = symbol.password;
		border = symbol.border;
		selectable = symbol.selectable;

		var format = new TextFormat ();
		if (symbol.color != null) format.color = (symbol.color & 0x00FFFFFF);
		format.size = Math.round (symbol.fontHeight / 20);

		format.font = SWFLite.fontAliases.get (symbol.fontName);
		if (format.font == null) {
			format.font = SWFLite.fontAliasesId.get (symbol.fontID);
		}
		if (format.font == null) {
			format.font = symbol.fontName;
		}

		var found = false;

		switch (format.font) {

			case "_sans", "_serif", "_typewriter", "", null:

				found = true;

			default:

				for (font in Font.enumerateFonts ()) {

					if (font.fontName == format.font) {

						found = true;
						break;

					}

				}

		}

		if (found) {

			embedFonts = true;

		} else {

			trace ("Warning: Could not find required font \"" + format.font + "\", it has not been embedded");

		}

		if (symbol.align != null) {

			if (symbol.align == "center") format.align = TextFormatAlign.CENTER;
			else if (symbol.align == "right") format.align = TextFormatAlign.RIGHT;
			else if (symbol.align == "justify") format.align = TextFormatAlign.JUSTIFY;

			format.leftMargin = Std.int (symbol.leftMargin / 20);
			format.rightMargin = Std.int (symbol.rightMargin / 20);
			format.indent = Std.int (symbol.indent / 20);
			format.leading = Std.int (symbol.leading / 20);
		}

		defaultTextFormat = format;

		if (symbol.text != null) {

			if (symbol.html) {
				htmlText = symbol.text;
			} else {
				text = symbol.text;
			}

		}

		if (symbol.maxLength != null) {
			maxChars = symbol.maxLength;
		}

		//autoSize = (tag.autoSize) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;

	}

	public override function __update (transformOnly:Bool, updateChildren:Bool):Void {
		if ( _variableName != null && _variableName.length > 0 ) {
			var local_parent = this.parent;
			while ( local_parent != null ) {
				if ( Reflect.hasField(local_parent, _variableName) ) {
					// :TODO: Support html text in this case
					text = Reflect.field(local_parent,_variableName);
					break;
				}
				local_parent = local_parent.parent;
			}
		}
		super.__update(transformOnly, updateChildren);
	}

}
