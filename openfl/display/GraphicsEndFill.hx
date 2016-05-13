package openfl.display; #if !openfl_legacy


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;


@:final class GraphicsEndFill implements IGraphicsData implements IGraphicsFill {
	
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	public function new () {
		
		this.__graphicsDataType = END;
		this.__graphicsFillType = END_FILL;
		
	}
	
	
}


#else
typedef GraphicsEndFill = openfl._legacy.display.GraphicsEndFill;
#end