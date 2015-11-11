package openfl.display3D; #if !flash

enum Context3DBufferUsage {
	
	STATIC_DRAW;
	DYNAMIC_DRAW;
	
}

#else
typedef Context3DBufferUsage = flash.display3D.Context3DBufferUsage;
#end