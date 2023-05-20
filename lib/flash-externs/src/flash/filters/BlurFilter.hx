package flash.filters;

#if flash
@:final extern class BlurFilter extends BitmapFilter
{
	#if (haxe_ver < 4.3)
	public var blurX:Float;
	public var blurY:Float;
	public var quality:Int;
	#else
	@:flash.property var blurX(get, set):Float;
	@:flash.property var blurY(get, set):Float;
	@:flash.property var quality(get, set):Int;
	#end

	public function new(blurX:Float = 4, blurY:Float = 4, quality:Int = 1);

	#if (haxe_ver >= 4.3)
	private function get_blurX():Float;
	private function get_blurY():Float;
	private function get_quality():Int;
	private function set_blurX(value:Float):Float;
	private function set_blurY(value:Float):Float;
	private function set_quality(value:Int):Int;
	#end
}
#else
typedef BlurFilter = openfl.filters.BlurFilter;
#end
