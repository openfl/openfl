package openfl._v2.display; #if lime_legacy


import openfl.geom.Matrix;
import openfl.Lib;


class GraphicsBitmapFill extends IGraphicsData implements IGraphicsFill {
	
	
	public var bitmapData:BitmapData;
	public var matrix:Matrix;
	public var repeat:Bool;
	public var smooth:Bool;
	
	
	public function new (bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {
		
		this.bitmapData = bitmapData;
		this.matrix = matrix;
		this.repeat = repeat;
		this.smooth = smooth;
		
		super (lime_graphics_solid_fill_create (0, 1));
		
	}
	
	
	private static var lime_graphics_solid_fill_create = Lib.load ("lime", "lime_graphics_solid_fill_create", 2);
	
	
}


#end