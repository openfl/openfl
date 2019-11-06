package openfl.display;

// import lime.graphics.CanvasRenderContext;
import openfl.geom.Matrix;

typedef CanvasRenderContext = js.html.CanvasRenderingContext2D;

#if !openfl_global
@:jsRequire("openfl/display/CanvasRenderer", "default")
#end
extern class CanvasRenderer extends DisplayObjectRenderer
{
	public var context:CanvasRenderContext;
	public var pixelRatio(default, null):Float;
	public function applySmoothing(context:CanvasRenderContext, value:Bool):Void;
	public function setTransform(transform:Matrix, context:CanvasRenderContext = null):Void;
}
