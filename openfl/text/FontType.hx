package openfl.text; #if !flash


enum FontType {
	
	DEVICE;
	EMBEDDED;
	EMBEDDED_CFF;
	
}


#else
typedef FontType = flash.text.FontType;
#end