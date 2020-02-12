package openfl.display;

#if (display || !flash)
@:jsRequire("openfl/display/GraphicsEndFill", "default")
/**
 * Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
 * `Graphics.drawGraphicsData()` method.
 *
 *  Drawing a GraphicsEndFill object is the equivalent of calling the
 * `Graphics.endFill()` method.
 */
@:final extern class GraphicsEndFill implements IGraphicsData implements IGraphicsFill
{
	/**
	 * Creates an object to use with the `Graphics.drawGraphicsData()`
	 * method to end the fill, explicitly.
	 */
	public function new();
}
#else
typedef GraphicsEndFill = flash.display.GraphicsEndFill;
#end
