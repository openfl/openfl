package openfl.display; #if !flash


enum SpreadMethod {
	
	REPEAT;
	REFLECT;
	PAD;
	
}


#else
typedef SpreadMethod = flash.display.SpreadMethod;
#end