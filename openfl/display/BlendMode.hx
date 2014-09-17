package openfl.display; #if !flash  #if (next || js)


enum BlendMode {
	
	ADD;
	ALPHA;
	DARKEN;
	DIFFERENCE;
	ERASE;
	HARDLIGHT;
	INVERT;
	LAYER;
	LIGHTEN;
	MULTIPLY;
	NORMAL;
	OVERLAY;
	SCREEN;
	SUBTRACT;
	
}


#else
typedef BlendMode = openfl._v2.display.BlendMode;
#end
#else
typedef BlendMode = flash.display.BlendMode;
#end