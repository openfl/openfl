package openfl.display;

import openfl._internal.backend.lime.Canvas2DRenderContext;
import openfl.geom.Matrix;

/**
	**BETA**

	The CanvasRenderer API exposes support for HTML5 canvas render instructions within the
	`RenderEvent.RENDER_CANVAS` event
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
class CanvasRenderer extends DisplayObjectRenderer
{
	/**
		The current HTML5 canvas render context
	**/
	public var context:#if lime Canvas2DRenderContext #else Dynamic #end;

	/**
		The active pixel ratio used during rendering
	**/
	public var pixelRatio(default, null):Float = 1;

	@:noCompletion private function new(context:#if lime Canvas2DRenderContext #else Dynamic #end)
	{
		super();

		this.context = context;
	}

	/**
		Set whether smoothing should be enabled on a canvas context
	**/
	public function applySmoothing(context:#if lime Canvas2DRenderContext #else Dynamic #end, value:Bool):Void {}

	/**
		Set the matrix value for the current render context, or (optionally) another canvas
		context
	**/
	public function setTransform(transform:Matrix, context:#if lime Canvas2DRenderContext #else Dynamic #end = null):Void {}
}
