package openfl.filters;

#if (display || !flash)
@:jsRequire("openfl/filters/ConvolutionFilter", "default")
@:final extern class ConvolutionFilter extends BitmapFilter
{
	public var alpha:Float;
	public var bias:Float;
	public var clamp:Bool;
	public var color:Int;
	public var divisor:Float;
	public var matrix(get, set):Array<Float>;
	@:noCompletion private function get_matrix():Array<Float>;
	@:noCompletion private function set_matrix(value:Array<Float>):Array<Float>;
	public var matrixX:Int;
	public var matrixY:Int;
	public var preserveAlpha:Bool;
	public function new(matrixX:Int = 0, matrixY:Int = 0, matrix:Array<Float> = null, divisor:Float = 1.0, bias:Float = 0.0, preserveAlpha:Bool = true,
		clamp:Bool = true, color:Int = 0, alpha:Float = 0.0):Void;
}
#else
typedef ConvolutionFilter = flash.filters.ConvolutionFilter;
#end
