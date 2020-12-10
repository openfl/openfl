package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;
import openfl.display._internal.GraphicsFillType;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsEndFill implements IGraphicsData implements IGraphicsFill
{
	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;

	public function new()
	{
		this.__graphicsDataType = END;
		this.__graphicsFillType = END_FILL;
	}
}
#else
typedef GraphicsEndFill = flash.display.GraphicsEndFill;
#end
