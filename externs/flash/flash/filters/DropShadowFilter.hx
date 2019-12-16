package flash.filters;

#if flash
@:final extern class DropShadowFilter extends BitmapFilter
{
	public var alpha:Float;
	public var angle:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var distance:Float;
	public var hideObject:Bool;
	public var inner:Bool;
	public var knockout:Bool;
	public var quality:Int;
	public var strength:Float;
	public function new(distance:Float = 4, angle:Float = 45, color:Int = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1,
		quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false);
}
#else
typedef DropShadowFilter = openfl.filters.DropShadowFilter;
#end
