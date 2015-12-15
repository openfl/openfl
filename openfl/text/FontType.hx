package openfl.text; #if !openfl_legacy


enum FontType {
	
	DEVICE;
	EMBEDDED;
	EMBEDDED_CFF;
	
}


#else
typedef FontType = openfl._legacy.text.FontType;
#end