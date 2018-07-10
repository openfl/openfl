package openfl.display;


import openfl.geom.Matrix;

#if (lime >= "7.0.0")
import lime.graphics.Canvas2DRenderContext;
#else
import lime.graphics.CanvasRenderContext;
#end


extern class CanvasRenderer extends DisplayObjectRenderer {
	
	
	public var context:#if (lime >= "7.0.0") Canvas2DRenderContext #else CanvasRenderContext #end;
	public var pixelRatio (default, null):Float;
	
	public function applySmoothing (context:#if (lime >= "7.0.0") Canvas2DRenderContext #else CanvasRenderContext #end, value:Bool):Void;
	public function setTransform (transform:Matrix, context:#if (lime >= "7.0.0") Canvas2DRenderContext #else CanvasRenderContext #end = null):Void;
	
	
}