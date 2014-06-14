package openfl.text; #if !flash


enum GridFitType {
	
	NONE;
	PIXEL;
	SUBPIXEL;
	
}


#else
typedef GridFitType = flash.text.GridFitType;
#end