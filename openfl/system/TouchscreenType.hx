package openfl.system; #if (!display && !flash)


enum TouchscreenType {
	
	FINGER;
	NONE;
	STYLUS;
	
}


#else


#if flash
@:native("flash.system.TouchscreenType")
#end

@:fakeEnum(String) extern enum TouchscreenType {
	
	FINGER;
	NONE;
	STYLUS;
	
}


#end