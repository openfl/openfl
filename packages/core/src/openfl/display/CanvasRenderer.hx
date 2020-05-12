package openfl.display;

import openfl.geom.Matrix;
#if lime
import lime.graphics.Canvas2DRenderContext;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.Canvas2DRenderContext;
#end

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
	public var context(get, set):#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end;

	/**
		The active pixel ratio used during rendering
	**/
	public var pixelRatio(get, never):Float;

	@:noCompletion private function new(context:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end)
	{
		if (_ == null)
		{
			_ = new _CanvasRenderer(context);
		}

		super();
	}

	/**
		Set whether smoothing should be enabled on a canvas context
	**/
	public function applySmoothing(context:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end, value:Bool):Void
	{
		_.applySmoothing(context, value);
	}

	/**
		Set the matrix value for the current render context, or (optionally) another canvas
		context
	**/
	public function setTransform(transform:Matrix, context:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end = null):Void
	{
		_.setTransform(transform, context);
	}

	// Get & Set Methods

	@:noCompletion private function get_context():#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end
	{
		return _.context;
	}

	@:noCompletion private function set_context(value:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end):#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end
	{
		return _.context = value;
	}

	@:noCompletion private function get_pixelRatio():Float
	{
		return _.pixelRatio;
	}
}
