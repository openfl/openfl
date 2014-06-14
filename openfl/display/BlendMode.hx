package openfl.display; #if !flash


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
typedef BlendMode = flash.display.BlendMode;
#end