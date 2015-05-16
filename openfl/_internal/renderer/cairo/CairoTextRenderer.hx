package openfl._internal.renderer.cairo;


import lime.graphics.Image;
import lime.text.Font.NativeGlyphData;
import lime.text.Glyph;
import lime.text.TextLayout;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

@:access(openfl.text.TextField)


class CairoTextRenderer {
		
	private static var glyphMap = new Map<Font, Array<NativeGlyphData>> ();
	
	
	public static function render (textField:TextField) {
		
		if (textField.__graphics == null) {
			
			textField.__graphics = new Graphics ();
			
		}
		
		if (textField.__dirty) {
			
			var graphics = textField.__graphics;
			graphics.clear ();
			
			if (textField.border || textField.background) {
				
				if (textField.border) {
					
					graphics.lineStyle (1, textField.borderColor);
					
				}
				
				if (textField.background) {
					
					graphics.beginFill (textField.backgroundColor);
					
				}
				
				graphics.drawRect (0.5, 0.5, textField.__width - 1, textField.__height - 1);
				
			}
			
			update( textField );
			
			textField.__dirty = false;
		}
	}
	
	public static function update (textField:TextField):Bool {
		
		if (textField.__dirty) {

			if (textField.__text != null && textField.__text != "") {
				
				var text = textField.text;
				
				if (textField.displayAsPassword) {
					
					var length = text.length;
					var mask = "";
					
					for (i in 0...length) {
						
						mask += "*";
						
					}
					
					text = mask;
					
				}
				
				var measurements = textField.__measureText ();
				var textWidth = 0.0;
				
				for (measurement in measurements) {
					
					textWidth += measurement;
					
				}
				
				if (textField.autoSize == TextFieldAutoSize.LEFT) {
					
					textField.__width = textWidth + 4;
					textField.__height = textField.textHeight + 4;
					
				}
				
				if (textField.__ranges == null) {
					
					renderText (textField, text, textField.__textFormat, 2, textWidth);
					
				} else {
					
					var currentIndex = 0;
					var range;
					var offsetX = 2.0;
					
					for (i in 0...textField.__ranges.length) {
						
						range = textField.__ranges[i];
						
						renderText (textField, text.substring (range.start, range.end), range.format, offsetX, textWidth);
						offsetX += measurements[i];
						
					}
					
				}
				
			} else {
				
				if (textField.autoSize == TextFieldAutoSize.LEFT) {
					
					textField.__width = 4;
					textField.__height = 4;
					
				}
				
			}
			
			textField.__dirty = false;
			return true;
		}
			
		return false;
		
	}

		private static inline function renderText (textField:TextField, text:String, format:TextFormat, offsetX:Float, textWidth:Float):Void {
		
		var font : Font = textField.__getFontInstance ( format );
		
		if (font != null && format.size != null) {
			
			var graphics : Graphics = textField.__graphics;

			var glyphs : Array<NativeGlyphData>;
			
			textField.__textLayout.font = font;
			
			if ( glyphMap.exists( font ) )
			{
				glyphs = glyphMap.get( font );
			}
			else
			{
				var glyphData  = font.decompose();
				glyphs = glyphData.glyphs;
				
				glyphMap.set( font, glyphs );
			}
			
			var tlm = textField.getLineMetrics (0);
			
			var x : Float = offsetX;
			var y : Float = 2 + tlm.ascent;
			
			var size = Std.int (format.size);
			
			var denom : Float = 20 / size * 1024;
			
			var lines = text.split ("\n");
			
			var line_i:Int = 0;
			var oldX = x;
			
			if (textField.__textLayout == null) {
				textField.__textLayout = new TextLayout ();
			}
			
			var textLayout:TextLayout = textField.__textLayout;
			
			var glyphCodes = new Map<Int,NativeGlyphData>();
			for ( g in glyphs )
			{
				glyphCodes.set( g.char_code, g );
			}
			
			for (line in lines)
			{
				tlm = textField.getLineMetrics (line_i);
				
				//x position must be reset every line and recalculated 
				x = oldX;
				
				x += switch (format.align) {
					
					case LEFT, JUSTIFY: 0;									//the renderer has already positioned the text at the right spot past the 2px left margin
					case CENTER: ((textField.__width - 4) - tlm.width) / 2;	//subtract 4 from textfield.__width because __width includes the 2px margin on both sides, which doesn't count
					case RIGHT:  ((textField.__width - 4) - tlm.width);		//same thing here
					
				}
				
				textLayout.text = null;
				textLayout.font = font;
				textLayout.size = size;
				textLayout.text = line;
				
				var a = 0;
				
				var tx : Float = 0;
				var ty : Float = 0;
				
				for (position in textLayout.positions)
				{
					var glyph = glyphCodes[ line.charCodeAt( a ) ]; 
					
					var points = glyph.points;
					
					var i = 0;
					
					graphics.beginFill( format.color );
									
					while( i < points.length )
					{				
						switch( points[i] )
						{
							case 1:
								
								tx = x + position.offset.x + points[i + 1]/denom;
								ty = y + position.offset.y - points[i + 2]/denom;
								
								graphics.moveTo( tx, ty );
								
								i += 3;
								
							case 2:
							
								tx += points[i + 1]/denom;
								ty -= points[i + 2]/denom;
								
								graphics.lineTo( tx, ty );
								
								i += 3;
								
							case 3:
							
								var cx = tx + points[i + 1]/denom;
								var cy = ty - points[i + 2]/denom;
								
								tx = cx + points[i + 3]/denom;
								ty = cy - points[i + 4]/denom;
								
								graphics.curveTo( cx, cy, tx, ty );
								i += 5;
								
							case 4:

								var c1x = tx + points[i + 1]/denom;
								var c1y = ty - points[i + 2]/denom;
								
								var c2x = c1x + points[i + 3]/denom;
								var c2y = c1y - points[i + 4]/denom;
								
								tx = c2x + points[i + 5]/denom;
								ty = c2y - points[i + 6]/denom;
								
								graphics.cubicCurveTo( c1x, c1y, c2x, c2y, tx, ty );
								i += 7;
						}
						
					}
					
					graphics.endFill( );

					x += position.advance.x;
					y -= position.advance.y;
					
					a++;
				}
				
				y += tlm.height;	//always add the line height at the end
				line_i++;
			}
		
		}
	}
	
	
}
