package flash.filters;

#if flash
import openfl.display.BitmapData;
import openfl.geom.Point;

@:final extern class DisplacementMapFilter extends BitmapFilter
{
	public var alpha:Float;
	public var color:Int;
	public var componentX:Int;
	public var componentY:Int;
	public var mapBitmap:BitmapData;
	public var mapPoint:Point;
	public var mode:DisplacementMapFilterMode;
	public var scaleX:Float;
	public var scaleY:Float;
	public function new(mapBitmap:BitmapData = null, mapPoint:Point = null, componentX:Int = 0, componentY:Int = 0, scaleX:Float = 0.0, scaleY:Float = 0.0,
		mode:DisplacementMapFilterMode = WRAP, color:Int = 0, alpha:Float = 0.0);
}
#else
typedef DisplacementMapFilter = openfl.filters.DisplacementMapFilter;
#end
