package openfl.display; #if !openfl_legacy


enum SpreadMethod {
	
	REPEAT;
	REFLECT;
	PAD;
	
}


#else
typedef SpreadMethod = openfl._legacy.display.SpreadMethod;
#end