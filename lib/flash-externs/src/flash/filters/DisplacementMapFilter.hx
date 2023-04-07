package flash.filters;

#if flash
import openfl.display.BitmapData;
import openfl.geom.Point;

@:final extern class DisplacementMapFilter extends BitmapFilter
{
	#if (haxe_ver < 4.3)
	public var alpha:Float;
	public var color:Int;
	public var componentX:Int;
	public var componentY:Int;
	public var mapBitmap:BitmapData;
	public var mapPoint:Point;
	public var mode:DisplacementMapFilterMode;
	public var scaleX:Float;
	public var scaleY:Float;
	#else
	@:flash.property var alpha(get, set):Float;
	@:flash.property var color(get, set):UInt;
	@:flash.property var componentX(get, set):UInt;
	@:flash.property var componentY(get, set):UInt;
	@:flash.property var mapBitmap(get, set):BitmapData;
	@:flash.property var mapPoint(get, set):Point;
	@:flash.property var mode(get, set):DisplacementMapFilterMode;
	@:flash.property var scaleX(get, set):Float;
	@:flash.property var scaleY(get, set):Float;
	#end

	public function new(mapBitmap:BitmapData = null, mapPoint:Point = null, componentX:Int = 0, componentY:Int = 0, scaleX:Float = 0.0, scaleY:Float = 0.0,
		mode:DisplacementMapFilterMode = WRAP, color:Int = 0, alpha:Float = 0.0);

	#if (haxe_ver >= 4.3)
	private function get_alpha():Float;
	private function get_color():UInt;
	private function get_componentX():UInt;
	private function get_componentY():UInt;
	private function get_mapBitmap():BitmapData;
	private function get_mapPoint():Point;
	private function get_mode():DisplacementMapFilterMode;
	private function get_scaleX():Float;
	private function get_scaleY():Float;
	private function set_alpha(value:Float):Float;
	private function set_color(value:UInt):UInt;
	private function set_componentX(value:UInt):UInt;
	private function set_componentY(value:UInt):UInt;
	private function set_mapBitmap(value:BitmapData):BitmapData;
	private function set_mapPoint(value:Point):Point;
	private function set_mode(value:DisplacementMapFilterMode):DisplacementMapFilterMode;
	private function set_scaleX(value:Float):Float;
	private function set_scaleY(value:Float):Float;
	#end
}
#else
typedef DisplacementMapFilter = openfl.filters.DisplacementMapFilter;
#end
