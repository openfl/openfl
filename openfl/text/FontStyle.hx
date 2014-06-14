package openfl.text; #if !flash


enum FontStyle {
	
	REGULAR;
	ITALIC;
	BOLD_ITALIC;
	BOLD;
	
}


#else
typedef FontStyle = flash.text.FontStyle;
#end