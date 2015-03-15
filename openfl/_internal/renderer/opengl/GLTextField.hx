package openfl._internal.renderer.opengl;


import lime.graphics.Image;
import lime.text.Font;
import lime.text.Glyph;
import lime.text.TextLayout;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Tilesheet;
import openfl.geom.Rectangle;
import openfl.text.TextField;

@:access(openfl.text.TextField)


class GLTextField {
	
	
	private static var bitmapData:BitmapData;
	private static var cacheText:String;
	private static var font:Font;
	private static var images:Map<Glyph, Image>;
	private static var textLayout:TextLayout;
	private static var tileData:Array<Float>;
	private static var tileID:Map <Int, Int>;
	private static var tilesheet:Tilesheet;
	
	
	public static function render (textField:TextField, renderSession:RenderSession) {
		
		if (!textField.__renderable || textField.__worldAlpha <= 0) return;
		
		if (textField.__graphics == null) {
			
			textField.__graphics = new Graphics ();
			
		}
		
		if (font == null && Assets.exists ("assets/KatamotzIkasi.ttf")) {
			
			font = Font.fromFile ("assets/KatamotzIkasi.ttf");
			
			var size:Int = textField.defaultTextFormat.size != null ? Std.int (textField.defaultTextFormat.size) : 12;
			
			textLayout = new TextLayout ();
			textLayout.font = font;
			textLayout.size = size;
			
			images = font.renderGlyphs (font.getGlyphs (), size);
			
			var width, height, data;
			
			for (image in images) {
				
				width = image.buffer.width;
				height = image.buffer.height;
				data = image.data;
				
				break;
				
			}
			
			bitmapData = new BitmapData (width, height);
			
			for (x in 0...width) {
				
				for (y in 0...height) {
					
					var alpha = data[(y * width) + x];
					var color = alpha << 24 | 0xFF << 16 | 0xFF << 8 | 0xFF;
					bitmapData.setPixel32 (x, y, color);
					
				}
				
			}
			
			tilesheet = new Tilesheet (bitmapData);
			tileID = new Map ();
			
			var image, index;
			
			for (key in images.keys ()) {
				
				image = images.get (key);
				index = tilesheet.addTileRect (new Rectangle (image.offsetX, image.offsetY, image.width, image.height));
				
				tileID.set (key, index);
				
			}
			
		}
		
		var graphics = textField.__graphics;
		
		
		if (textField.text != null && textField.text != "") {
			
			if (textField.text != cacheText) {
				
				graphics.clear ();
				
				cacheText = textField.text;
				textLayout.text = textField.text;
				
				var r = (textField.defaultTextFormat.color >> 16) & 0xFF;
				var g = (textField.defaultTextFormat.color >> 8) & 0xFF;
				var b = (textField.defaultTextFormat.color) & 0xFF;
				
				var image;
				var x = textField.__worldTransform.tx;
				var y = textField.__worldTransform.tx + textField.defaultTextFormat.size;
				
				tileData = [];
				
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
					
				}
				
				graphics.drawTiles (tilesheet, tileData, true, Tilesheet.TILE_RGB);
				
			}
			
		} else {
			
			graphics.clear ();
			
		}
		
		GraphicsRenderer.render (textField, renderSession);
		
	}
	
	
}