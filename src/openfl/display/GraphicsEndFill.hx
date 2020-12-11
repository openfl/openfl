package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;
import openfl.display._internal.GraphicsFillType;

/**
	Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
	`Graphics.drawGraphicsData()` method.

	Drawing a GraphicsEndFill object is the equivalent of calling the
	`Graphics.endFill()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsEndFill implements IGraphicsData implements IGraphicsFill
{
	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;

	/**
		Creates an object to use with the `Graphics.drawGraphicsData()`
		method to end the fill, explicitly.
	**/
	public function new()
	{
		this.__graphicsDataType = END;
		this.__graphicsFillType = END_FILL;
	}
}
#else
typedef GraphicsEndFill = flash.display.GraphicsEndFill;
#end
