package openfl.text;


#if flash
@:native("flash.text.GridFitType")
#end


@:fakeEnum(String) extern enum GridFitType {
	
	NONE;
	PIXEL;
	SUBPIXEL;
	
}