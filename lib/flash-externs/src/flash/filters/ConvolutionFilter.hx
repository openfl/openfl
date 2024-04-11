package flash.filters;

#if flash
@:final extern class ConvolutionFilter extends BitmapFilter
{
	#if (haxe_ver < 4.3)
	public var alpha:Float;
	public var bias:Float;
	public var clamp:Bool;
	public var color:Int;
	public var divisor:Float;
	public var matrix:Array<Float>;
	public var matrixX:Int;
	public var matrixY:Int;
	public var preserveAlpha:Bool;
	#else
	@:flash.property var alpha(get, set):Float;
	@:flash.property var bias(get, set):Float;
	@:flash.property var clamp(get, set):Bool;
	@:flash.property var color(get, set):UInt;
	@:flash.property var divisor(get, set):Float;
	@:flash.property var matrix(get, set):Array<Float>;
	@:flash.property var matrixX(get, set):Float;
	@:flash.property var matrixY(get, set):Float;
	@:flash.property var preserveAlpha(get, set):Bool;
	#end

	public function new(matrixX:Int = 0, matrixY:Int = 0, matrix:Array<Float> = null, divisor:Float = 1.0, bias:Float = 0.0, preserveAlpha:Bool = true,
		clamp:Bool = true, color:Int = 0, alpha:Float = 0.0):Void;

	#if (haxe_ver >= 4.3)
	private function get_alpha():Float;
	private function get_bias():Float;
	private function get_clamp():Bool;
	private function get_color():UInt;
	private function get_divisor():Float;
	private function get_matrix():Array<Float>;
	private function get_matrixX():Float;
	private function get_matrixY():Float;
	private function get_preserveAlpha():Bool;
	private function set_alpha(value:Float):Float;
	private function set_bias(value:Float):Float;
	private function set_clamp(value:Bool):Bool;
	private function set_color(value:UInt):UInt;
	private function set_divisor(value:Float):Float;
	private function set_matrix(value:Array<Float>):Array<Float>;
	private function set_matrixX(value:Float):Float;
	private function set_matrixY(value:Float):Float;
	private function set_preserveAlpha(value:Bool):Bool;
	#end
}
#else
typedef ConvolutionFilter = openfl.filters.ConvolutionFilter;
#end
