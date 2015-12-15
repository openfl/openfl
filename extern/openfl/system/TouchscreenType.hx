package openfl.system;


#if flash
@:native("flash.system.TouchscreenType")
#end


@:fakeEnum(String) extern enum TouchscreenType {
	
	FINGER;
	NONE;
	STYLUS;
	
}