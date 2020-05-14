package openfl.display;

#if !flash
import openfl._internal.renderer.GraphicsDataType;
import openfl._internal.renderer.GraphicsFillType;

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
	@:allow(openfl) @:noCompletion private var _:Any;

	/**
		Creates an object to use with the `Graphics.drawGraphicsData()`
		method to end the fill, explicitly.
	**/
	public function new()
	{
		_ = new _GraphicsEndFill(this);
	}
}
#else
typedef GraphicsEndFill = flash.display.GraphicsEndFill;
#end
