package flash.display;
#if (flash || display)


/**
 * Defines a solid fill.
 *
 * <p> Use a GraphicsSolidFill object with the
 * <code>Graphics.drawGraphicsData()</code> method. Drawing a
 * GraphicsSolidFill object is the equivalent of calling the
 * <code>Graphics.beginFill()</code> method. </p>
 */
@:final extern class GraphicsSolidFill implements IGraphicsData  implements IGraphicsFill {

	/**
	 * Indicates the alpha transparency value of the fill. Valid values are 0
	 * (fully transparent) to 1(fully opaque). The default value is 1. Display
	 * objects with alpha set to 0 are active, even though they are invisible.
	 */
	var alpha : Float;

	/**
	 * The color of the fill. Valid values are in the hexadecimal format
	 * 0xRRGGBB. The default value is 0xFF0000(or the uint 0).
	 */
	var color : Int;

	/**
	 * Creates a new GraphicsSolidFill object.
	 * 
	 * @param color The color value. Valid values are in the hexadecimal format
	 *              0xRRGGBB.
	 * @param alpha The alpha transparency value. Valid values are 0(fully
	 *              transparent) to 1(fully opaque).
	 */
	function new(color : Int = 0, alpha : Float = 1) : Void;
}


#end
