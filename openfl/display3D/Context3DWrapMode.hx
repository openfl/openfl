package openfl.display3D; #if (!display && !flash)


enum Context3DWrapMode {
	
	CLAMP;
	REPEAT;
	
}


#else


#if flash
@:native("flash.display.Context3DWrapMode")
#end

@:fakeEnum(String) extern enum Context3DWrapMode {
	
	CLAMP;
	
	#if (flash && !display)
	CLAMP_U_REPEAT_V;
	#end
	
	REPEAT;
	
	#if (flash && !display)
	REPEAT_U_CLAMP_V;
	#end
	
}


#end