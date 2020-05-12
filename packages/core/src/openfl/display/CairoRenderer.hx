package openfl.display;

#if !flash
import lime.graphics.cairo.Cairo;
import openfl.geom.Matrix;
#if lime
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
	public var cairo(get, set):#if lime CairoRenderContext #else Dynamic #end;

	@:noCompletion private function new(cairo:#if lime Cairo #else Dynamic #end)
	{
		if (_ == null)
		{
			_ = new _CairoRenderer(cairo);
		}

		super();
	}

	/**
		Set the matrix value for the current render context, or (optionally) another Cairo
		object
	**/
	public function applyMatrix(transform:Matrix, cairo:#if lime Cairo #else Dynamic #end = null):Void
	{
		_.applyMatrix(transform, cairo);
	}

	// Get & Set Methods

	@:noCompletion private function get_cairo():#if lime CairoRenderContext #else Dynamic #end
	{
		return _.cairo;
	}

	@:noCompletion private function set_cairo(value:#if lime CairoRenderContext #else Dynamic #end):#if lime CairoRenderContext #else Dynamic #end
	{
		return _.cairo = value;
	}
}
#else
typedef CairoRenderer = Dynamic;
#end
