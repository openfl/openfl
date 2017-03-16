package openfl._internal.symbols;


import openfl._internal.swf.SWFLite;
import openfl.display.Shape;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class StaticTextSymbol extends SWFSymbol {
	
	
	public var matrix:Matrix;
	public var records:Array<StaticTextRecord>;
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
		
		if (records != null) {
			
			var font:FontSymbol = null;
			var color = 0xFFFFFF;
			var offsetX = matrix.tx;
			var offsetY = matrix.ty;
			
			for (record in records) {
				
				if (record.fontID != null) font = cast swf.symbols.get (record.fontID);
				if (record.offsetX != null) offsetX = matrix.tx + record.offsetX * 0.05;
				if (record.offsetY != null) offsetY = matrix.ty + record.offsetY * 0.05;
				if (record.color != null) color = record.color;
				
				if (font != null) {
					
					var scale = (record.fontHeight / 1024) * 0.05;
					
					var index;
					var code;
					
					for (i in 0...record.glyphs.length) {
						
						index = record.glyphs[i];
						
						for (command in font.glyphs[index]) {
							
							switch (command) {
								
								case BeginFill (_, alpha):
									
									graphics.beginFill (color & 0xFFFFFF, ((color >> 24) & 0xFF) / 0xFF);
								
								case CurveTo (controlX, controlY, anchorX, anchorY):
									
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
						
						offsetX += record.advances[i] * 0.05;
						
					}
					
				}
				
			}
			
		}
		
		records = null;
		rendered = new Shape ();
		rendered.graphics.copyFrom (shape.graphics);
		
		return shape;
		
	}
	
	
}


@:keep class StaticTextRecord {
	
	
	public var advances:Array<Int>;
	public var color:Null<Int>;
	public var fontHeight:Int;
	public var fontID:Null<Int>;
	public var glyphs:Array<Int>;
	public var offsetX:Null<Int>;
	public var offsetY:Null<Int>;
	
	
	public function new () {
		
		
		
	}
	
	
}