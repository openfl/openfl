package openfl.display;

#if (display || !flash)
@:jsRequire("openfl/display/GraphicsSolidFill", "default")
/**
 * Defines a solid fill.
 *
 *  Use a GraphicsSolidFill object with the
 * `Graphics.drawGraphicsData()` method. Drawing a
 * GraphicsSolidFill object is the equivalent of calling the
 * `Graphics.beginFill()` method.
 */
@:final extern class GraphicsSolidFill implements IGraphicsData implements IGraphicsFill
{
	/**
	 * Indicates the alpha transparency value of the fill. Valid values are 0
	 * (fully transparent) to 1(fully opaque). The default value is 1. Display
	 * objects with alpha set to 0 are active, even though they are invisible.
	 */
	public var alpha:Float;

	/**
	 * The color of the fill. Valid values are in the hexadecimal format
	 * 0xRRGGBB. The default value is 0xFF0000(or the uint 0).
	 */
	public var color:UInt;

	/**
	 * Creates a new GraphicsSolidFill object.
	 *
	 * @param color The color value. Valid values are in the hexadecimal format
	 *              0xRRGGBB.
	 * @param alpha The alpha transparency value. Valid values are 0(fully
	 *              transparent) to 1(fully opaque).
	 */
	public function new(color:UInt = 0, alpha:Float = 1);
}
#else
typedef GraphicsSolidFill = flash.display.GraphicsSolidFill;
#end
