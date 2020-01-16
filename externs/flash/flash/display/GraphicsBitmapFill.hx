package flash.display;

#if flash
import openfl.geom.Matrix;

@:final extern class GraphicsBitmapFill implements IGraphicsData implements IGraphicsFill
{
	public var bitmapData:BitmapData;
	public var matrix:Matrix;
	public var repeat:Bool;
	public var smooth:Bool;
	public function new(bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false);
}
#else
typedef GraphicsBitmapFill = openfl.display.GraphicsBitmapFill;
#end
