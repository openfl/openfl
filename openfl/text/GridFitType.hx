package openfl.text; #if (!display && !flash)


enum GridFitType {
	
	NONE;
	PIXEL;
	SUBPIXEL;
	
}


#else


#if flash
@:native("flash.text.GridFitType")
#end

@:fakeEnum(String) extern enum GridFitType {
	
	NONE;
	PIXEL;
	SUBPIXEL;
	
}


#end