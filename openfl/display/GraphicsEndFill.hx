package openfl.display; #if !flash #if !lime_legacy


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;


/**
 * Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
 * <code>Graphics.drawGraphicsData()</code> method.
 *
 * <p> Drawing a GraphicsEndFill object is the equivalent of calling the
 * <code>Graphics.endFill()</code> method. </p>
 */
class GraphicsEndFill implements IGraphicsData implements IGraphicsFill {
	
	
	@:noCompletion public var __graphicsDataType (default,null):GraphicsDataType;
	@:noCompletion public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	/**
	 * Creates an object to use with the <code>Graphics.drawGraphicsData()</code>
	 * method to end the fill, explicitly.
	 */
	public function new () {
		
		this.__graphicsDataType = END;
		this.__graphicsFillType = END_FILL;
		
	}
	
	
}


#else
typedef GraphicsEndFill = openfl._v2.display.GraphicsEndFill;
#end
#else
typedef GraphicsEndFill = flash.display.GraphicsEndFill;
#end