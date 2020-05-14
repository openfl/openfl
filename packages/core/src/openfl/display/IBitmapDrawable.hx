package openfl.display;

#if !flash
interface IBitmapDrawable
{
	@:allow(openfl) @:noCompletion private var _:Any;
}
#else
typedef IBitmapDrawable = flash.display.IBitmapDrawable;
#end
