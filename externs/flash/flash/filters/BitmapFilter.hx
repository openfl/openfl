package flash.filters;

#if flash
extern class BitmapFilter
{
	public function new():Void;
	public function clone():BitmapFilter;
}
#else
typedef BitmapFilter = openfl.filters.BitmapFilter;
#end
