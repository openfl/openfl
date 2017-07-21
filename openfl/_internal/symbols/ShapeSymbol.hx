package openfl._internal.symbols;


import openfl._internal.swf.ShapeCommand;
import openfl._internal.swf.SWFLite;
import openfl.display.BitmapData;
import openfl.display.Shape;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.symbols.BitmapSymbol)


class ShapeSymbol extends SWFSymbol {
	
	
	public var commands:Array<ShapeCommand>;
	public var rendered:Shape;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	private override function __createObject (swf:SWFLite):Shape {
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		
		if (rendered != null) {
			
			graphics.copyFrom (rendered.graphics);
			return shape;
			
		}
		
		for (command in commands) {
			
			switch (command) {
				
				case BeginFill (color, alpha):
					
					graphics.beginFill (color, alpha);
				
				case BeginBitmapFill (bitmapID, matrix, repeat, smooth):
					
					var bitmapSymbol:BitmapSymbol = cast swf.symbols.get (bitmapID);
					var bitmap = swf.library.getImage (bitmapSymbol.path);
					
					if (bitmap != null) {
						
						graphics.beginBitmapFill (BitmapData.fromImage (bitmap), matrix, repeat, smooth);
						
					}
				
				case BeginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):
					
					graphics.beginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
				
				case CurveTo (controlX, controlY, anchorX, anchorY):
					
					graphics.curveTo (controlX, controlY, anchorX, anchorY);
				
				case EndFill:
					
					graphics.endFill ();
				
				case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
					
					if (thickness != null) {
						
						graphics.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
						
					} else {
						
						graphics.lineStyle ();
						
					}
				
				case LineTo (x, y):
					
					graphics.lineTo (x, y);
				
				case MoveTo (x, y):
					
					graphics.moveTo (x, y);
				
			}
			
		}
		
		commands = null;
		rendered = new Shape ();
		rendered.graphics.copyFrom (shape.graphics);
		
		return shape;
		
	}
	
	
}