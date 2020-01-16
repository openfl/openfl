package flash.display;

#if flash
extern interface IBitmapDrawable {}
#else
typedef IBitmapDrawable = openfl.display.IBitmapDrawable;
#end
