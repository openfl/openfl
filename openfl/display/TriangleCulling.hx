package openfl.display; #if !openfl_legacy


enum TriangleCulling {
	
	NEGATIVE;
	NONE;
	POSITIVE;
	
}


#else
typedef TriangleCulling = openfl._legacy.display.TriangleCulling;
#end