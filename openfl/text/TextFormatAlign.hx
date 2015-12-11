package openfl.text; #if !openfl_legacy


enum TextFormatAlign {
	
	LEFT;
	RIGHT;
	JUSTIFY;
	CENTER;
	
}


#else
typedef TextFormatAlign = openfl._legacy.text.TextFormatAlign;
#end