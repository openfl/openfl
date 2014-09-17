package openfl.display; #if !flash #if (display || next || js)


enum LineScaleMode {
	
	HORIZONTAL;
	NONE;
	NORMAL;
	VERTICAL;
	
}


#else
typedef LineScaleMode = openfl._v2.display.LineScaleMode;
#end
#else
typedef LineScaleMode = flash.display.LineScaleMode;
#end