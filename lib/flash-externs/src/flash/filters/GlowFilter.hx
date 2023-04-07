package flash.filters;

#if flash
@:final extern class GlowFilter extends BitmapFilter
{
	#if (haxe_ver < 4.3)
	public var alpha:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var inner:Bool;
	public var knockout:Bool;
	public var quality:Int;
	public var strength:Float;
	#else
	@:flash.property var alpha(get, set):Float;
	@:flash.property var blurX(get, set):Float;
	@:flash.property var blurY(get, set):Float;
	@:flash.property var color(get, set):UInt;
	@:flash.property var inner(get, set):Bool;
	@:flash.property var knockout(get, set):Bool;
	@:flash.property var quality(get, set):Int;
	@:flash.property var strength(get, set):Float;
	#end

	public function new(color:Int = 0xFF0000, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false,
		knockout:Bool = false);

	#if (haxe_ver >= 4.3)
	private function get_alpha():Float;
	private function get_blurX():Float;
	private function get_blurY():Float;
	private function get_color():UInt;
	private function get_inner():Bool;
	private function get_knockout():Bool;
	private function get_quality():Int;
	private function get_strength():Float;
	private function set_alpha(value:Float):Float;
	private function set_blurX(value:Float):Float;
	private function set_blurY(value:Float):Float;
	private function set_color(value:UInt):UInt;
	private function set_inner(value:Bool):Bool;
	private function set_knockout(value:Bool):Bool;
	private function set_quality(value:Int):Int;
	private function set_strength(value:Float):Float;
	#end
}
#else
typedef GlowFilter = openfl.filters.GlowFilter;
#end
