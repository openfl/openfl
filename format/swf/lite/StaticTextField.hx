package format.swf.lite;


import flash.display.Shape;
import flash.geom.Point;
import format.swf.lite.symbols.FontSymbol;
import format.swf.lite.symbols.StaticTextSymbol;
import format.swf.lite.SWFLite;


class StaticTextField extends Shape {
	
	
	private var symbol:StaticTextSymbol;
	
	
	public function new (swf:SWFLite, symbol:StaticTextSymbol) {
		
		super ();
		
		this.symbol = symbol;
		
		if (symbol.records != null) {
			
			var font:FontSymbol = null;
			var color = 0xFFFFFF;
			var x = symbol.matrix.tx;
			var y = symbol.matrix.ty;
			
			for (record in symbol.records) {
				
				if (record.fontID != null) font = cast swf.symbols.get (record.fontID);
				if (record.offsetX != null) x = symbol.matrix.tx + record.offsetX * 0.05;
				if (record.offsetY != null) y = symbol.matrix.ty + record.offsetY * 0.05;
				if (record.color != null) color = record.color;
				
				if (font != null) {

					var scale = (record.fontHeight / 1024);

					if ( symbol.shapeIsScaled ){
						scale *= 0.05;
					}

					var index;
					var code;
					
					for (i in 0...record.glyphs.length) {
						
						index = record.glyphs[i];
						renderGlyph (font, index, color, scale, x, y);
						x += record.advances[i] * 0.05;
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	private function renderGlyph (font:FontSymbol, character:Int, color:Int, scale:Float, offsetX:Float, offsetY:Float):Void {
		
		for (command in font.glyphs[character]) {
			
			switch (command) {
				
				case BeginFill (_, alpha):
					
					graphics.beginFill (color & 0xFFFFFF, ((color >> 24) & 0xFF) / 0xFF);
				
				case CurveTo (controlX, controlY, anchorX, anchorY):
					
					#if (cpp || neko)
					cacheAsBitmap = true;
					#end
					graphics.curveTo (controlX * scale + offsetX, controlY * scale + offsetY, anchorX * scale + offsetX, anchorY * scale + offsetY);
				
				case EndFill:
					
					graphics.endFill ();
				
				case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
					
					if (thickness != null) {
						
						graphics.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
						
					} else {
						
						graphics.lineStyle ();
						
					}
				
				case LineTo (x, y):
					
					graphics.lineTo (x * scale + offsetX, y * scale + offsetY);
				
				case MoveTo (x, y):
					
					graphics.moveTo (x * scale + offsetX, y * scale + offsetY);
				
				default:
				
			}
			
		}
		
	}
	
	
}