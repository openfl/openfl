package openfl._internal.renderer.cairo;

import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoFont;
import lime.graphics.cairo.CairoFontOptions;
import lime.graphics.cairo.CairoSurface;
import lime.math.Matrix3;
import lime.text.Font.NativeGlyphData;
import lime.text.TextLayout;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Rectangle;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextLineMetrics;

@:access(openfl.display.Graphics)
@:access(openfl.display.BitmapData)
@:access(openfl.text.TextField)
@:access(openfl.geom.Matrix)

class CairoTextField {
	
	public static function render ( textField:TextField, renderSession:RenderSession ) {
							
		if ( !textField.__dirty ) return;

		var bounds = textField.getBounds( null );
		var format = textField.getTextFormat();
		
		var graphics : Graphics = textField.__graphics;
		var cairo : Cairo = graphics.__cairo;
		
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
			
			var bitmap = new BitmapData( Math.ceil (bounds.width), Math.ceil (bounds.height), true );
			var surface = CairoSurface.fromImage( bitmap.__image ); 
			graphics.__cairo = new Cairo (surface);
			surface.destroy ();
			
			graphics.__bitmap = bitmap;		
			graphics.__bounds = new Rectangle( 0, 0, bounds.width, bounds.height );
			
			cairo = graphics.__cairo;
			
			var options = new CairoFontOptions();
			options.hintStyle = FULL;
			options.hintMetrics = ON;
			options.antialias = GOOD;
			cairo.setFontOptions( options );
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
		cairo.rectangle( 0.5, 0.5, Std.int( textField.width )-1, Std.int( textField.height )-1 );
		
		// Clear the surface
		if ( !textField.background )
		{
			cairo.operator = SOURCE;
			cairo.setSourceRGBA( 1, 1, 1, 0 );
			cairo.paint();
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
				
				renderText (textField, text, textField.__textFormat, 2, bounds );
				
			} else {
				
				var currentIndex = 0;
				var range;
				var offsetX = 2.0;
				
				for (i in 0...textField.__ranges.length) {
					
					range = textField.__ranges[i];
					
					renderText (textField, text.substring (range.start, range.end), range.format, offsetX, bounds);
					offsetX += measurements[i];
					
				}
				
			}
			
		}
		
		graphics.__bitmap.__image.dirty = true;
		textField.__dirty = false;
	}
	
	private static function renderText( textField : TextField, text : String, format : TextFormat, offsetX:Float, bounds:Rectangle )
	{
		var font : Font = textField.__getFontInstance ( format );
		
		if (font != null && format.size != null) {
			
			var graphics : Graphics = textField.__graphics;
						
			var tlm = textField.getLineMetrics(0);

			var x : Float = offsetX;
			var y : Float = 2 + tlm.ascent;
			
			var size = Std.int (format.size);

			var lines : Array<String> = text.split("\n");
			
			var line_i:Int = 0;
			var oldX = x;
			
			var cairo = textField.__graphics.__cairo;
			cairo.setFontSize( size );
			
			var color = format.color;
			
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;
			 
			cairo.setSourceRGB( r, g, b );
			
			for (line in lines)
			{
				//tlm = textField.getLineMetrics (line_i);
				
				x = oldX;
				
				x += switch (format.align) {
					
					case LEFT, JUSTIFY: 0;	
					case CENTER: ((textField.width-4) - textField.__getLineWidth( line_i ) ) / 2;
					case RIGHT:  ((textField.width-4) - textField.__getLineWidth( line_i ) );
					
				}
				
				cairo.moveTo( x, y );
				cairo.showText( line );
				
				y += Math.round( tlm.height + tlm.descent + format.leading - 1 );
				line_i++;
			}
		
		}
		
		
	}
}
