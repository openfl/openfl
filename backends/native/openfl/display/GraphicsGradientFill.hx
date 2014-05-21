package openfl.display;


import openfl.geom.Matrix;
import openfl.Lib;


class GraphicsGradientFill extends IGraphicsData {
	
	
	public function new (type:GradientType = null, colors:Array<Int> = null, alphas:Array<Float> = null, ratios:Array<Float> = null, matrix:Matrix = null, spreadMethod:SpreadMethod = null, interpolationMethod:InterpolationMethod = null, focalPointRatio:Float = 0):Void {
		
		super (lime_graphics_solid_fill_create (0, 1));
		
	}
	
	
	private static var lime_graphics_solid_fill_create = Lib.load ("lime", "lime_graphics_solid_fill_create", 2);
	
	
}