package openfl._internal.renderer;


import lime.graphics.Image;
import lime.text.Glyph;
import lime.text.TextLayout;
import openfl._internal.renderer.cairo.CairoTextField;
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


class TextFieldGraphics {
	
	
	private static var bitmapData = new Map<Font, Map<Int, BitmapData>> ();
	private static var glyphs = new Map<Font, Map<Int, Map<Glyph, Image>>> ();
	private static var tilesheets = new Map<BitmapData, Tilesheet> ();
	private static var tileIDs = new Map<BitmapData, Map<Glyph, Int>> ();
	
	
	public static function render (textField:TextField) {
		
		var bounds = textField.getBounds( null );
		
		update (textField, bounds);
		
		if (textField.__graphics == null) {
			
			textField.__graphics = new Graphics ();
			
		}
		
		var graphics = textField.__graphics;
		graphics.clear ();
		
		if (textField.border || textField.background) {
			
			if (textField.border) {
				
				graphics.lineStyle (1, textField.borderColor);
				
			}
			
			if (textField.background) {
				
				graphics.beginFill (textField.backgroundColor);
				
			}
			
			graphics.drawRect (bounds.x + 0.5, bounds.y+0.5, bounds.width - 1, bounds.height - 1);
			
		}
		
		if (textField.__tileData != null) {
			
			for (tilesheet in textField.__tilesheets.keys ()) {
				
				graphics.drawTiles (tilesheet, textField.__tileData.get (tilesheet), true, Tilesheet.TILE_RGB, textField.__tileDataLength.get (tilesheet));
				
			}
			
		}
		
	}
	
	
	private static inline function renderText (textField:TextField, text:String, format:TextFormat, offsetX:Float, bounds:Rectangle):Void {
		
		var font = CairoTextField.getFontInstance (format);
		
		if (font != null && format.size != null) {
			
			if (!glyphs.exists (font)) {
				
				glyphs.set (font, new Map ());
				
			}
			
			var size = Std.int (format.size);
			var fontGlyphs = glyphs.get (font);
			
			if (!fontGlyphs.exists (size)) {
				
				fontGlyphs.set (size, font.renderGlyphs (font.getGlyphs (), size));
				
			}
			
			var images = fontGlyphs.get (size);
			
			if (!bitmapData.exists (font)) {
				
				bitmapData.set (font, new Map ());
				
			}
			
			var fontBitmapData = bitmapData.get (font);
			
			if (!fontBitmapData.exists (size)) {
				
				var width, height, data;
				
				for (image in images) {
					
					width = image.buffer.width;
					height = image.buffer.height;
					data = image.data;
					break;
					
				}
				
				var bitmapData = new BitmapData (width, height);
				
				for (x in 0...width) {
					
					for (y in 0...height) {
						
						var alpha = data[(y * width) + x];
						var color = alpha << 24 | 0xFF << 16 | 0xFF << 8 | 0xFF;
						bitmapData.setPixel32 (x, y, color);
						
					}
					
				}
				
				fontBitmapData.set (size, bitmapData);
				
			}
			
			var bitmapData = fontBitmapData.get (size);
			
			if (!tilesheets.exists (bitmapData)) {
				
				var tilesheet = new Tilesheet (bitmapData);
				var tileID = new Map<Int, Int> ();
				
				var image, index;
				
				for (key in images.keys ()) {
					
					image = images.get (key);
					index = tilesheet.addTileRect (new Rectangle (image.offsetX, image.offsetY, image.width, image.height));
					
					tileID.set (key, index);
				}
				
				tileIDs.set (bitmapData, tileID);
				tilesheets.set (bitmapData, tilesheet);
				
			}
			
			var tilesheet = tilesheets.get (bitmapData);
			var tileID = tileIDs.get (bitmapData);
			
			var r = ((format.color >> 16) & 0xFF) / 0xFF;
			var g = ((format.color >> 8) & 0xFF) / 0xFF;
			var b = ((format.color) & 0xFF) / 0xFF;
			
			var tlm = textField.getLineMetrics(0);
			
			var image;
			var x:Float = offsetX;
			var y:Float = 2 + tlm.ascent;
			
			//If you render with y == 0, the bottom pixel of the "T" in "The Quick Brown Fox" will rest on TOP of your text field.
			//Flash API text fields have a 2px margin on all sides, so (2 + ASCENT) puts your text right where it needs to be.
			
			var tileData;
			
			textField.__tilesheets.set (tilesheet, true);
			
			if (!textField.__tileData.exists (tilesheet)) {
				
				tileData = new Array ();
				textField.__tileData.set (tilesheet, tileData);
				textField.__tileDataLength.set (tilesheet, 0);
				
			}
			
			tileData = textField.__tileData.get (tilesheet);
			
			var offsetY = 0;
			var lines = text.split ("\n");
			
			if (textField.__textLayout == null) {
				
				textField.__textLayout = new TextLayout ();
				
			}
			
			var textLayout:TextLayout = textField.__textLayout;
			var length = 0;
			
			var line_i:Int = 0;
			var oldX = x;
			
			for (line in lines) {
				
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
				
				for (position in textLayout.positions) {
					
					image = images.get (position.glyph);
					
					if (image != null) {
						
						if (length >= tileData.length) {
							
							tileData.push (x + position.offset.x + image.x);
							tileData.push (y + position.offset.y - image.y);
							tileData.push (tileID.get (position.glyph));
							tileData.push (r);
							tileData.push (g);
							tileData.push (b);
							
						} else {
							
							tileData[length] = x + position.offset.x + image.x;
							tileData[length + 1] = y + position.offset.y - image.y;
							tileData[length + 2] = tileID.get (position.glyph);
							tileData[length + 3] = r;
							tileData[length + 4] = g;
							tileData[length + 5] = b;
							
						}
						
						length += 6;
						
					}
					
					x += position.advance.x;
					y -= position.advance.y;
					
				}
				
				y += tlm.height;	//always add the line height at the end
				line_i++;
				
			}
			
			textField.__tileDataLength.set (tilesheet, length);
			
		}
		
	}
	
	
	public static function update (textField:TextField, bounds:Rectangle):Bool {
		
		if (textField.__dirty) {
			
			if (((textField.__text == null || textField.__text == "") && !textField.background && !textField.border) || ((textField.width <= 0 || textField.height <= 0) && textField.autoSize != TextFieldAutoSize.LEFT)) {
				
				textField.__tilesheets = null;
				textField.__tileData = null;
				textField.__tileDataLength = null;
				textField.__dirty = false;
				
			} else {
				
				textField.__tilesheets = new Map ();
				
				if (textField.__tileData == null) {
					
					textField.__tileData = new Map ();
					textField.__tileDataLength = new Map ();
					
				}
				
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
					
					var measurements = CairoTextField.measureText (textField);
					
					if (textField.__ranges == null) {
						
						renderText (textField, text, textField.__textFormat, 2, bounds );
						
					} else {
						
						var currentIndex = 0;
						var range;
						var offsetX = 2.0;
						
						for (i in 0...textField.__ranges.length) {
							
							range = textField.__ranges[i];
							
							renderText (textField, text.substring (range.start, range.end), range.format, offsetX, bounds );
							offsetX += measurements[i];
							
						}
						
					}
					
				}
				
				for (key in textField.__tileData.keys ()) {
					
					if (!textField.__tilesheets.exists (key)) {
						
						textField.__tileData.remove (key);
						textField.__tileDataLength.remove (key);
						
					}
					
				}
				
				textField.__dirty = false;
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
}
