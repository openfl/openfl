package openfl._internal.backend.lime_standalone;

#if openfl_html5
import js.html.CanvasRenderingContext2D;

@:access(lime.graphics.RenderContext)
@:forward()
abstract Canvas2DRenderContext(CanvasRenderingContext2D) from CanvasRenderingContext2D to CanvasRenderingContext2D
{
	@:from private static function fromRenderContext(context:RenderContext):Canvas2DRenderContext
	{
		return context.canvas2D;
	}
}
#end
