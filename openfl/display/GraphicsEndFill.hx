package openfl.display; #if !flash #if (next || js)


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;


class GraphicsEndFill implements IGraphicsData implements IGraphicsFill {
	
	
	public var __graphicsDataType (default,null):GraphicsDataType;
	public var __graphicsFillType (default, null):GraphicsFillType;
	
	
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