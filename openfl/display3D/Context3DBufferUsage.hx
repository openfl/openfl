package openfl.display3D; #if (!display && !flash)


enum Context3DBufferUsage {
	
	STATIC_DRAW;
	DYNAMIC_DRAW;
	
}


#else


#if flash
@:native("flash.display3D.Context3DBufferUsage")
@:require(flash12)
#end

@:fakeEnum(String) extern enum Context3DBufferUsage {
	
	DYNAMIC_DRAW;
	STATIC_DRAW;
	
}


#end