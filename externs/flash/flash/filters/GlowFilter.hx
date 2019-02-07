package flash.filters;

#if flash
@:final extern class GlowFilter extends BitmapFilter
{
	public var alpha:Float;
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var inner:Bool;
	public var knockout:Bool;
	public var quality:Int;
	public var strength:Float;
	public function new(color:Int = 0xFF0000, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false,
		knockout:Bool = false);
}
#else
typedef GlowFilter = openfl.filters.GlowFilter;
#end
