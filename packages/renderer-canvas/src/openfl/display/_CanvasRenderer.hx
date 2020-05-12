package openfl.display;

import openfl.geom.Matrix;
#if lime
import lime.graphics.Canvas2DRenderContext;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.Canvas2DRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
@:noCompletion
class _CanvasRenderer extends _DisplayObjectRenderer
{
	public var context:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end;
	public var pixelRatio(default, null):Float = 1;

	public function new(context:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end)
	{
		super();

		this.context = context;
	}

	public function applySmoothing(context:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end, value:Bool):Void {}

	public function setTransform(transform:Matrix, context:#if (lime || openfl_html5) Canvas2DRenderContext #else Dynamic #end = null):Void {}
}
