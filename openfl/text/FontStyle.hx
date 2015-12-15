package openfl.text; #if !openfl_legacy


enum FontStyle {
	
	REGULAR;
	ITALIC;
	BOLD_ITALIC;
	BOLD;
	
}


#else
typedef FontStyle = openfl._legacy.text.FontStyle;
#end