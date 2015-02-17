package openfl.display; #if !flash #if !lime_legacy


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;


/**
 * Defines a solid fill.
 *
 * <p> Use a GraphicsSolidFill object with the
 * <code>Graphics.drawGraphicsData()</code> method. Drawing a
 * GraphicsSolidFill object is the equivalent of calling the
 * <code>Graphics.beginFill()</code> method. </p>
 */
class GraphicsSolidFill implements IGraphicsData implements IGraphicsFill {
	
	
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
	
	@:noCompletion @:dox(hide) public var __graphicsDataType (default, null):GraphicsDataType;
	@:noCompletion @:dox(hide) public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	/**
	 * Creates a new GraphicsSolidFill object.
	 * 
	 * @param color The color value. Valid values are in the hexadecimal format
	 *              0xRRGGBB.
	 * @param alpha The alpha transparency value. Valid values are 0(fully
	 *              transparent) to 1(fully opaque).
	 */
	public function new (color:UInt = 0, alpha:Float = 1) {
		
		this.alpha = alpha;
		this.color = color;
		this.__graphicsDataType = SOLID;
		this.__graphicsFillType = SOLID_FILL;
		
	}
	
	
}


#else
typedef GraphicsSolidFill = openfl._v2.display.GraphicsSolidFill;
#end
#else
typedef GraphicsSolidFill = flash.display.GraphicsSolidFill;
#end