package openfl._v2.display; #if lime_legacy


import openfl.display.GradientType;
import openfl.display.InterpolationMethod;
import openfl.geom.Matrix;
import openfl.Lib;


class GraphicsGradientFill extends IGraphicsData implements IGraphicsFill {
	
	public var alphas:Array<Float>;
	public var colors:Array<Int>;
	public var focalPointRatio:Float;
	public var interpolationMethod:InterpolationMethod;
	public var matrix:Matrix;
	public var ratios:Array<Float>;
	public var spreadMethod:SpreadMethod;
	public var type:GradientType;
	
	
	public function new (type:GradientType = null, colors:Array<Int> = null, alphas:Array<Float> = null, ratios:Array<Float> = null, matrix:Matrix = null, spreadMethod:SpreadMethod = null, interpolationMethod:InterpolationMethod = null, focalPointRatio:Float = 0):Void {
		
		super (lime_graphics_solid_fill_create (0, 1));
		
		if (type == null) {
			
			type = GradientType.LINEAR;
			
		}
		
		if (spreadMethod == null) {
			
			spreadMethod = SpreadMethod.PAD;
			
		}
		
		if (interpolationMethod == null) {
			
			interpolationMethod = InterpolationMethod.RGB;
			
		}
		
		this.type = type;
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
		this.matrix = matrix;
		this.spreadMethod = spreadMethod;
		this.interpolationMethod = interpolationMethod;
		this.focalPointRatio = focalPointRatio;
		
	}
	
	
	private static var lime_graphics_solid_fill_create = Lib.load ("lime", "lime_graphics_solid_fill_create", 2);
	
	
}


#end