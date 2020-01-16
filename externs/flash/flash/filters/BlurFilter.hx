package flash.filters;

#if flash
@:final extern class BlurFilter extends BitmapFilter
{
	public var blurX:Float;
	public var blurY:Float;
	public var quality:Int;
	public function new(blurX:Float = 4, blurY:Float = 4, quality:Int = 1);
}
#else
typedef BlurFilter = openfl.filters.BlurFilter;
#end
