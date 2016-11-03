package openfl._internal.swf;


import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl._internal.symbols.DynamicTextSymbol;
import openfl._internal.symbols.FontSymbol;
import openfl._internal.swf.SWFLite;


class DynamicTextField extends TextField {
	
	
	public var symbol:DynamicTextSymbol;
	
	private var glyphs:Array<Shape>;
	private var swf:SWFLite;
	private var _text:String;
	
	
	public function new (swf:SWFLite, symbol:DynamicTextSymbol) {
		
		super ();
		
		this.swf = swf;
		this.symbol = symbol;
		
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
		
		var font:FontSymbol = cast swf.symbols.get (symbol.fontID);
		
		if (font != null) {
			
			// TODO: Bold and italic are handled in the font already
			// Setting this can cause "extra" bold in HTML5
			
			//format.bold = font.bold;
			//format.italic = font.italic;
			//format.leading = Std.int (font.leading / 20 + (format.size * 0.2) #if flash + 2 #end);
			//embedFonts = true;
			
		}
		
		format.font = symbol.fontName;
		
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
			
			if (embedFonts) format.leading += 4; // TODO: Why is this necessary?
			
		}
		
		defaultTextFormat = format;

		if (symbol.text != null) {

			#if !flash

			var plain = new EReg ("</p>", "g").replace (symbol.text, "\n");
			plain = new EReg ("<br>", "g").replace (plain, "\n");
			plain = new EReg ("<.*?>", "g").replace (plain, "");
			text = StringTools.htmlUnescape (plain);

			#else

			if (symbol.html) {

				htmlText = symbol.text;

			} else {

				text = symbol.text;

			}

			#end

		}

		//autoSize = (tag.autoSize) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
		
	}
	
	
}
