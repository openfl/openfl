package openfl.text; #if !flash


enum TextFieldAutoSize {
	
	CENTER;
	LEFT;
	NONE;
	RIGHT;
	
}


#else
typedef TextFieldAutoSize = flash.text.TextFieldAutoSize;
#end