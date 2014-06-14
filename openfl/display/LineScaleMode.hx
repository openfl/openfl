package openfl.display; #if !flash


enum LineScaleMode {
	
	HORIZONTAL;
	NONE;
	NORMAL;
	VERTICAL;
	
}


#else
typedef LineScaleMode = flash.display.LineScaleMode;
#end