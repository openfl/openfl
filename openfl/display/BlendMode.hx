package openfl.display; #if !openfl_legacy


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
	SHADER;
	SUBTRACT;
	
}


#else
typedef BlendMode = openfl._legacy.display.BlendMode;
#end