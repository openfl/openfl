package openfl.text; #if !flash


enum TextFieldType {
	
	DYNAMIC;
	INPUT;
	
}


#else
typedef TextFieldType = flash.text.TextFieldType;
#end