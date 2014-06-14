package openfl.display; #if !flash


enum TriangleCulling {
	
	NEGATIVE;
	NONE;
	POSITIVE;
	
}


#else
typedef TriangleCulling = flash.display.TriangleCulling;
#end