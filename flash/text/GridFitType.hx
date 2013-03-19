package flash.text;
#if (flash || display)


@:fakeEnum(String) extern enum GridFitType {
	NONE;
	PIXEL;
	SUBPIXEL;
}


#else
typedef GridFitType = nme.text.GridFitType;
#end
