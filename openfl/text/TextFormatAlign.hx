package openfl.text; #if !flash


enum TextFormatAlign {
	
	LEFT;
	RIGHT;
	JUSTIFY;
	CENTER;
	
}


#else
typedef TextFormatAlign = flash.text.TextFormatAlign;
#end