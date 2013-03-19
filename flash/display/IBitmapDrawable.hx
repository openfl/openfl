package flash.display;
#if (flash || display)


extern interface IBitmapDrawable {
}


#else
typedef IBitmapDrawable = nme.display.IBitmapDrawable;
#end
