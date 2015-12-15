package openfl.display; #if !openfl_legacy


enum LineScaleMode {
	
	HORIZONTAL;
	NONE;
	NORMAL;
	VERTICAL;
	
}


#else
typedef LineScaleMode = openfl._legacy.display.LineScaleMode;
#end