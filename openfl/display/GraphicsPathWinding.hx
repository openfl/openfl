package openfl.display; #if !flash


@:fakeEnum(String) enum GraphicsPathWinding {
	
	EVEN_ODD;
	NON_ZERO;
	
}


#else
typedef GraphicsPathWinding = flash.display.GraphicsPathWinding;
#end