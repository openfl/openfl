package openfl.display;


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class GraphicsEndFill implements IGraphicsData implements IGraphicsFill {
	
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	public function new () {
		
		this.__graphicsDataType = END;
		this.__graphicsFillType = END_FILL;
		
	}
	
	
}