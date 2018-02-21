package format.swf.instance;


import format.swf.exporters.ShapeCommandExporter;
import format.swf.instance.Bitmap;
import format.swf.tags.TagDefineMorphShape;
import format.swf.SWFTimelineContainer;


class MorphShape extends flash.display.Shape {
	
	private var tag:TagDefineMorphShape;
	private var handler:ShapeCommandExporter;
	private var data:SWFTimelineContainer;
	
	public function new (data:SWFTimelineContainer, tag:TagDefineMorphShape) {
		
		super ();
		
		handler = new ShapeCommandExporter (data);
		this.tag = tag;
		this.tag.exportHandler = handler;
		this.data = data;
		
		//render();
		
		//if (tag != null) {
			
			//var handler = new ShapeCommandExporter (data);
			//tag.export (handler);
			//....
			
			
		//}
		
	}
	
	
	public function render (ratio:Float = 0):Void {
		
		tag.export(ratio / 65536.0);
		graphics.clear();
		
		for (command in handler.commands) {
			
			switch (command) {
					
				case BeginFill (color, alpha):
					
					graphics.beginFill (color, alpha);
				
				case BeginBitmapFill (bitmapID, matrix, repeat, smooth):
					
					var bitmap = new Bitmap (cast data.getCharacter (bitmapID));
					
					if (bitmap.bitmapData != null) {
						
						graphics.beginBitmapFill (bitmap.bitmapData, matrix, repeat, smooth);
						
					}
				
				case BeginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):
					
					#if (cpp || neko)
					cacheAsBitmap = true;
					#end
					graphics.beginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
				
				case CurveTo (controlX, controlY, anchorX, anchorY):
					
					#if (cpp || neko)
					//cacheAsBitmap = true;
					#end
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
		
	}
	
}