package format.swf.lite;


import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import format.swf.lite.symbols.FontSymbol;
import format.swf.lite.symbols.TextSymbol;
import format.swf.lite.SWFLite;


class TextField extends Sprite {
	
	
	public var text (get, set):String;
	
	private var glyphs:Array<Shape>;
	private var swf:SWFLite;
	private var symbol:TextSymbol;
	private var _text:String;
	
	
	public function new (swf:SWFLite, symbol:TextSymbol) {
		
		super ();
		
		this.swf = swf;
		this.symbol = symbol;
		
		glyphs = new Array<Shape> ();
		_text = symbol.text;
		
		if (_text != null) {
			
			update ();
			
		}
		
	}
	
	
	private function renderGlyph (font:FontSymbol, character:Int, scale:Float, offsetX:Float, offsetY:Float):Void {
		
		for (command in font.glyphs[character]) {
			
			switch (command.type) {
				
				//case BEGIN_FILL: shape.graphics.beginFill (command.params[0], command.params[1]);
				case BEGIN_FILL: graphics.beginFill (symbol.color != null ? symbol.color & 0xFFFFFF : 0x000000, symbol.color != null ? ((symbol.color >> 24) & 0xFF) / 0xFF : 1);
				case END_FILL: graphics.endFill ();
				case LINE_STYLE: 
					
					if (command.params.length > 0) {
						
						graphics.lineStyle (command.params[0], command.params[1], command.params[2], command.params[3], command.params[4], command.params[5], command.params[6], command.params[7]);
						
					} else {
						
						graphics.lineStyle ();
						
					}
				
				case MOVE_TO: graphics.moveTo (command.params[0] * scale + offsetX, command.params[1] * scale + offsetY);
				case LINE_TO: graphics.lineTo (command.params[0] * scale + offsetX, command.params[1] * scale + offsetY);
				case CURVE_TO: 
					
					cacheAsBitmap = true;
					graphics.curveTo (command.params[0] * scale + offsetX, command.params[1] * scale + offsetY, command.params[2] * scale + offsetX, command.params[3] * scale + offsetY);
					
				default:
				
			}
			
		}
		
	}
	
	
	private function update ():Void {
		
		graphics.clear ();
		
		if (swf.symbols.exists (symbol.fontID)) {
			
			var font:FontSymbol = cast swf.symbols.get (symbol.fontID);
			var scale = (symbol.fontHeight / 1024) * 0.05;
			var x = 0.0;
			var y = font.ascent * scale * 0.05;
			
			for (i in 0..._text.length) {
				
				var index = -1;
				
				for (j in 0...font.codes.length) {
					
					if (font.codes[j] == _text.charCodeAt (i)) {
						
						index = j;
						
					}
					
				}
				
				if (index > -1) {
					
					renderGlyph (font, index, scale, x, y);
					x += scale * font.advances[index] * 0.05;
					
				}
				
			}
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_text ():String {
		
		return _text;
		
	}
	
	
	private function set_text (value:String):String {
		
		if (value != _text) {
			
			_text = value;
			update ();
			
		}
		
		return _text;
		
	}
	
	
}