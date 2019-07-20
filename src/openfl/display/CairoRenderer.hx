package openfl.display;

#if !flash
import openfl.geom.Matrix;
#if lime
import lime.graphics.cairo.Cairo;
import lime.graphics.CairoRenderContext;
#end

/**
	**BETA**

	The CairoRenderer API exposes support for native Cairo render instructions within the
	`RenderEvent.RENDER_CAIRO` event
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
class CairoRenderer extends DisplayObjectRenderer
{
	/**
		The current Cairo render context
	**/
	public var cairo:#if lime CairoRenderContext #else Dynamic #end;

	@:noCompletion private function new(cairo:#if lime Cairo #else Dynamic #end)
	{
		super();

		this.cairo = cairo;
	}

	/**
		Set the matrix value for the current render context, or (optionally) another Cairo
		object
	**/
	public function applyMatrix(transform:Matrix, cairo:#if lime Cairo #else Dynamic #end = null):Void {}
}
#else
typedef CairoRenderer = Dynamic;
#end
