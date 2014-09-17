package openfl.display; #if !flash #if (next || js)


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;
import openfl.geom.Matrix;
import openfl.Lib;


class GraphicsBitmapFill implements IGraphicsData implements IGraphicsFill {
	
	
	public var bitmapData:BitmapData;
	public var matrix:Matrix;
	public var repeat:Bool;
	public var smooth:Bool;
	
	public var __graphicsDataType (default,null):GraphicsDataType;
	public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	public function new (bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {
		
		this.bitmapData = bitmapData;
		this.matrix = matrix;
		this.repeat = repeat;
		this.smooth = smooth;
		
		this.__graphicsDataType = BITMAP;
		this.__graphicsFillType = BITMAP_FILL;
		
	}
	
	
}


#else
typedef GraphicsBitmapFill = openfl._v2.display.GraphicsBitmapFill;
#end
#else
typedef GraphicsBitmapFill = flash.display.GraphicsBitmapFill;
#end