package openfl.system; #if !flash


enum TouchscreenType {
	
	FINGER;
	NONE;
	STYLUS;
	
}


#else
typedef TouchscreenType = flash.system.TouchscreenType;
#end