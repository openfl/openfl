package flash.display;

#if flash
import openfl.geom.Matrix;

@:final extern class GraphicsGradientFill implements IGraphicsData implements IGraphicsFill
{
	#if (haxe_ver < 4.3)
	public var interpolationMethod:InterpolationMethod;
	public var spreadMethod:SpreadMethod;
	public var type:GradientType;
	#else
	@:flash.property var interpolationMethod(get, set):InterpolationMethod;
	@:flash.property var spreadMethod(get, set):SpreadMethod;
	@:flash.property var type(get, set):GradientType;
	#end

	public var alphas:Array<Float>;
	public var colors:Array<UInt>;
	public var focalPointRatio:Float;
	public var matrix:Matrix;
	public var ratios:Array<UInt>;

	public function new(?type:GradientType, colors:Array<UInt> = null, alphas:Array<Float> = null, ratios:Array<UInt> = null, matrix:Matrix = null,
		?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Float = 0);

	#if (haxe_ver >= 4.3)
	private function get_interpolationMethod():InterpolationMethod;
	private function get_spreadMethod():SpreadMethod;
	private function get_type():GradientType;
	private function set_interpolationMethod(value:InterpolationMethod):InterpolationMethod;
	private function set_spreadMethod(value:SpreadMethod):SpreadMethod;
	private function set_type(value:GradientType):GradientType;
	#end
}
#else
typedef GraphicsGradientFill = openfl.display.GraphicsGradientFill;
#end
