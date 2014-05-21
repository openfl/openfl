package openfl.display;


import openfl.geom.Matrix;
import openfl.Lib;


class GraphicsBitmapFill extends IGraphicsData {
	
	
	public function new (bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {
		
		super (lime_graphics_solid_fill_create (0, 1));
		
	}
	
	
	private static var lime_graphics_solid_fill_create = Lib.load ("lime", "lime_graphics_solid_fill_create", 2);
	
	
}