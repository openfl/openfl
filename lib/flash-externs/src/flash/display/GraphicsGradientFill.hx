package flash.display;

#if flash
import openfl.geom.Matrix;

@:final extern class GraphicsGradientFill implements IGraphicsData implements IGraphicsFill
{
	public var alphas:Array<Float>;
	public var colors:Array<UInt>;
	public var focalPointRatio:Float;
	public var interpolationMethod:InterpolationMethod;
	public var matrix:Matrix;
	public var ratios:Array<UInt>;
	public var spreadMethod:SpreadMethod;
	public var type:GradientType;
	public function new(?type:GradientType, colors:Array<UInt> = null, alphas:Array<Float> = null, ratios:Array<UInt> = null, matrix:Matrix = null,
		?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Float = 0);
}
#else
typedef GraphicsGradientFill = openfl.display.GraphicsGradientFill;
#end
