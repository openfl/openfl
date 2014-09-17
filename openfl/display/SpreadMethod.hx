package openfl.display; #if !flash #if (display || next || js)


enum SpreadMethod {
	
	REPEAT;
	REFLECT;
	PAD;
	
}


#else
typedef SpreadMethod = openfl._v2.display.SpreadMethod;
#end
#else
typedef SpreadMethod = flash.display.SpreadMethod;
#end