package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DBufferUsage")
@:require(flash12)
#end


@:fakeEnum(String) extern enum Context3DBufferUsage {
	
	DYNAMIC_DRAW;
	STATIC_DRAW;
	
}