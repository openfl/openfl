package openfl.display;


import openfl.display.IGraphicsData;
import openfl.display.IGraphicsFill;
import openfl.geom.Matrix;


class GraphicsGradientFill implements IGraphicsData implements IGraphicsFill {
	
	
	public var alphas:Array<Float>;
	public var colors:Array<Int>;
	public var focalPointRatio:Float;
	public var interpolationMethod:InterpolationMethod;
	public var matrix:Matrix;
	public var ratios:Array<Float>;
	public var spreadMethod:SpreadMethod;
	public var type:GradientType;
	
	public var __graphicsDataType (default,null):GraphicsDataType;
	public var __graphicsFillType (default, null):GraphicsFillType;
	
	
	public function new (type:GradientType = null, colors:Array<Int> = null, alphas:Array<Float> = null, ratios:Array<Float> = null, matrix:Matrix = null, spreadMethod:SpreadMethod = null, interpolationMethod:InterpolationMethod = null, focalPointRatio:Float = 0) {
		
		this.type = type;
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
		this.matrix = matrix;
		this.spreadMethod = spreadMethod;
		this.interpolationMethod = interpolationMethod;
		this.focalPointRatio = focalPointRatio;
		this.__graphicsDataType = GRADIENT;
		this.__graphicsFillType = GRADIENT_FILL;
		
	}
	
	
}