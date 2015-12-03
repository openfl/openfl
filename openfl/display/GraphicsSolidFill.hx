package openfl.display; #if (!display && !flash) #if !openfl_legacy


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;


@:final class GraphicsSolidFill implements IGraphicsData implements IGraphicsFill {
	
	
	public var alpha:Float;
	public var color:UInt;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	public function new (color:UInt = 0, alpha:Float = 1) {
		
		this.alpha = alpha;
		this.color = color;
		this.__graphicsDataType = SOLID;
		this.__graphicsFillType = SOLID_FILL;
		
	}
	
	
}


#else
typedef GraphicsSolidFill = openfl._legacy.display.GraphicsSolidFill;
#end
#else


/**
 * Defines a solid fill.
 *
 * <p> Use a GraphicsSolidFill object with the
 * <code>Graphics.drawGraphicsData()</code> method. Drawing a
 * GraphicsSolidFill object is the equivalent of calling the
 * <code>Graphics.beginFill()</code> method. </p>
 */

#if flash
@:native("flash.display.GraphicsSolidFill")
#end

@:final extern class GraphicsSolidFill implements IGraphicsData implements IGraphicsFill {
	
	
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
	public function new (color:UInt = 0, alpha:Float = 1);
	
	
}


#end