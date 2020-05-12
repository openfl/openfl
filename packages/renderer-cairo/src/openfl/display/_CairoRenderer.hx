package openfl.display;

import lime.graphics.cairo.Cairo;
import openfl.geom.Matrix;
#if lime
import lime.graphics.CairoRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
@:noCompletion
class _CairoRenderer extends _DisplayObjectRenderer
{
	public var cairo:#if lime CairoRenderContext #else Dynamic #end;

	public function new(cairo:#if lime Cairo #else Dynamic #end)
	{
		super();

		this.cairo = cairo;
	}

	public function applyMatrix(transform:Matrix, cairo:#if lime Cairo #else Dynamic #end = null):Void {}
}
