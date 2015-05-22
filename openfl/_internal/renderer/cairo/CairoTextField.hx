package openfl._internal.renderer.cairo;

import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoFont;
import lime.graphics.cairo.CairoFontOptions;
import lime.graphics.cairo.CairoSurface;
import lime.text.Font.NativeGlyphData;
import lime.text.TextLayout;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Graphics;
import openfl.geom.Rectangle;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

@:access(openfl.text.TextField)
@:access(openfl.geom.Matrix)

class CairoTextField {
		
	public static function render (textField:TextField, renderSession:RenderSession):Void {
				
		if (!textField.__renderable || textField.__worldAlpha <= 0) return;
				
		var bounds = textField.getBounds( null );
		
		__render (textField, renderSession, bounds );
		
		if (textField.__cairo != null) {
			
			if (textField.__mask != null) {
				
				renderSession.maskManager.pushMask (textField.__mask);
				
			}
			
			var cairo = renderSession.cairo;
			var scrollRect = textField.scrollRect;
			
			//context.globalAlpha = shape.__worldAlpha;
			var transform = textField.__worldTransform;
			
			cairo.identityMatrix();
			
			if (renderSession.roundPixels) {
				
				cairo.translate( Math.round( bounds.x ), Math.round( bounds.y ) );
				
			} else {
				
				cairo.translate( bounds.x, bounds.y );
			}			

			cairo.setSourceSurface (textField.__cairo.target, 0, 0 );
			
			if (scrollRect != null) {
				
				cairo.pushGroup ();
				cairo.newPath ();
				cairo.rectangle (bounds.x + scrollRect.x, bounds.y + scrollRect.y, scrollRect.width, scrollRect.height);
				cairo.fill ();
				cairo.popGroupToSource ();
				
			}
			
			cairo.paintWithAlpha (textField.__worldAlpha);
			
			if (textField.__mask != null) {
				
				renderSession.maskManager.popMask ();
				
			}
			
		}
		
	}
	
	private static inline function __render (textField:TextField, renderSession:RenderSession, bounds:Rectangle) {
		
		if ( textField.__dirty )
		{
			var format = textField.getTextFormat();
			var cairo = textField.__cairo;
			
			// See if our surface is still the correct size
			if (cairo != null) {
				
				var surface = cairo.target;
				
				if (Math.ceil (bounds.width) != surface.width || Math.ceil (bounds.height) != surface.height) {
										
					cairo.destroy ();
					cairo = null;
				}
			}
			
			// See if we need to create a new surface
			if (cairo == null) {
				
				var surface = new CairoSurface (ARGB32, Math.ceil (bounds.width), Math.ceil (bounds.height) );

				cairo = new Cairo (surface);
				textField.__cairo = cairo;
				surface.destroy ();				
			}

			var font : Font = textField.__getFontInstance ( format );
			
			if ( textField.__cairoFont != null )
			{
				if ( textField.__cairoFont.font != font )
				{
					textField.__cairoFont.destroy();
					textField.__cairoFont = null;
				}
			}
			
			if ( textField.__cairoFont == null )
			{
				textField.__cairoFont = new CairoFont( font );
			}
			
			cairo.setFontFace( textField.__cairoFont );
			cairo.rectangle( 0.5, 0.5, Std.int( bounds.width )-1, Std.int( bounds.height )-1 );
			
			// Clear the surface
			if ( !textField.background )
			{
				cairo.operator = SOURCE;
				cairo.setSourceRGBA( 1, 1, 1, 0 );
				cairo.fillPreserve();
				cairo.operator = OVER;
			}
			else
			{
				var color = textField.backgroundColor;
			
				var r = ((color & 0xFF0000) >>> 16) / 0xFF;
				var g = ((color & 0x00FF00) >>> 8) / 0xFF;
				var b = (color & 0x0000FF) / 0xFF;
				
				cairo.setSourceRGB( r, g, b );
				cairo.fillPreserve();
			}
			
			if ( textField.border )
			{
				var color = textField.borderColor;
			
				var r = ((color & 0xFF0000) >>> 16) / 0xFF;
				var g = ((color & 0x00FF00) >>> 8) / 0xFF;
				var b = (color & 0x0000FF) / 0xFF;
				
				cairo.setSourceRGB( r, g, b );
				cairo.lineWidth = 1;
				cairo.stroke();
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
				
				var measurements = textField.__measureText ();
				
				if (textField.__ranges == null) {
					
					renderText (textField, text, textField.__textFormat, 2 );
					
				} else {
					
					var currentIndex = 0;
					var range;
					var offsetX = 2.0;
					
					for (i in 0...textField.__ranges.length) {
						
						range = textField.__ranges[i];
						
						renderText (textField, text.substring (range.start, range.end), range.format, offsetX);
						offsetX += measurements[i];
						
					}
					
				}
				
			}

			textField.__dirty = false;
		}
	}
	
	private static function renderText( textField : TextField, text : String, format : TextFormat, offsetX:Float )
	{
		var font : Font = textField.__getFontInstance ( format );
		
		if (font != null && format.size != null) {
			
			var graphics : Graphics = textField.__graphics;

			textField.__textLayout.font = font;
						
			var tlm = textField.getLineMetrics(0);
			
			var x : Float = offsetX;
			var y : Float = 2 + tlm.ascent;
			
			var size = Std.int (format.size);

			var lines : Array<String> = text.split("\n");
			
			var line_i:Int = 0;
			var oldX = x;
			
			if (textField.__textLayout == null) {
				textField.__textLayout = new TextLayout ();
			}
				
			var cairo = textField.__cairo;
					
			cairo.setFontSize( size );
			
			var color = format.color;
			
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;
			 
			cairo.setSourceRGB( r, g, b );
			
			for (line in lines)
			{
				tlm = textField.getLineMetrics (line_i);
				
				x = oldX;
				
				x += switch (format.align) {
					
					case LEFT, JUSTIFY: 0;	
					case CENTER: ((textField.__width - 4) - tlm.width) / 2;
					case RIGHT:  ((textField.__width - 4) - tlm.width);
					
				}
				
				cairo.moveTo( x, y );
				cairo.showText( line );
				
				y += Math.round( tlm.height + tlm.descent + format.leading - 1 );
				line_i++;
			}
		
		}
		
		
	}
}
