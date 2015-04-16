package openfl._internal.renderer.opengl;


import haxe.Utf8;
import lime.graphics.Image;
import lime.text.Glyph;
import lime.text.TextLayout;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
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


class GLTextField {
	
	
	private static var bitmapData = new Map<Font, Map<Int, BitmapData>> ();
	private static var glyphs = new Map<Font, Map<Int, Map<Glyph, Image>>> ();
	private static var tilesheets = new Map<BitmapData, Tilesheet> ();
	private static var tileIDs = new Map<BitmapData, Map<Glyph, Int>> ();
	
	
	public static function render (textField:TextField, renderSession:RenderSession) {
		
		if (!textField.__renderable || textField.__worldAlpha <= 0) return;
		
		update (textField);
		
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
			
			graphics.drawRect (0.5, 0.5, textField.__width - 1, textField.__height - 1);
			
		}
		
		if (textField.__tilesheets != null) {
			
			for (i in 0...textField.__tilesheets.length) {
				
				graphics.drawTiles (textField.__tilesheets[i], textField.__tileData[i], true, Tilesheet.TILE_RGB);
				
			}
			
		}
		
		GraphicsRenderer.render (textField, renderSession);
		
	}
	
	
	private static inline function renderText (textField:TextField, text:String, format:TextFormat, offsetX:Float, textWidth:Float):Void {
		
		var dodebug = (textField.defaultTextFormat.font.toLowerCase().indexOf("liberation") != -1);
		
		var font = textField.__getFontInstance (format);
		
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
			
			if (dodebug)
			{
				//trace("textField." + textField.
			}
			
			var tlm = textField.getLineMetrics(0);
			
			var image;
			var x:Float = offsetX;
			var y:Float = size - tlm.descent / 2;
			
			var tileData;
			
			if (textField.__tilesheets.length == 0 || textField.__tilesheets[textField.__tilesheets.length - 1] != tilesheet) {
				
				tileData = new Array ();
				
				textField.__tilesheets.push (tilesheet);
				textField.__tileData.push (tileData);
				
			} else {
				
				tileData = textField.__tileData[textField.__tileData.length - 1];
				
			}
			
			var offsetY = 0;
			var lines = text.split ("\n");
			
			if (textField.__textLayout == null) {
				
				textField.__textLayout = new TextLayout ();
				
			}
			
			var textLayout:TextLayout = textField.__textLayout;
			
			var line_i:Int = 0;
			
			for (line in lines) {
				
				tlm = textField.getLineMetrics(line_i);
				
				x = offsetX;
				
				x += switch(format.align)
				{
					case LEFT, JUSTIFY: 0;
					case RIGHT: (textField.__width - tlm.width) - 4;	//not sure why -4 works, I expected -2
					case CENTER: (textField.__width - tlm.width) / 2;
				}
				
				textLayout.text = null;
				textLayout.font = font;
				textLayout.size = size;
				textLayout.text = line;
				
				for (position in textLayout.positions) {
					
					image = images.get (position.glyph);
					
					if (image != null) {
						
						tileData.push (x + position.offset.x + image.x);
						tileData.push (y + position.offset.y - image.y);
						tileData.push (tileID.get (position.glyph));
						tileData.push (r);
						tileData.push (g);
						tileData.push (b);
						
					}
					
					x += position.advance.x;
					y -= position.advance.y;
					
					if (dodebug)
					{
						trace("y = " + y);
					}
				}
				
				var tlm = textField.getLineMetrics(line_i);
				
				y += tlm.height;
				
				line_i++;
			}
			
		}
		
	}
	
	
	public static function update (textField:TextField):Bool {
		
		if (textField.__dirty) {
			
			if (((textField.__text == null || textField.__text == "") && !textField.background && !textField.border) || ((textField.width <= 0 || textField.height <= 0) && textField.autoSize != TextFieldAutoSize.LEFT)) {
				
				textField.__tilesheets = null;
				textField.__tileData = null;
				textField.__dirty = false;
				
			} else {
				
				//if (textField.__tilesheets == null) {
					
					textField.__tilesheets = new Array ();
					textField.__tileData = new Array ();
					
				//}
				
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
			
		}
		
		return false;
		
	}
	
	
}