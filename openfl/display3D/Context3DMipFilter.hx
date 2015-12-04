package openfl.display3D; #if (!display && !flash)


enum Context3DMipFilter {
	
	MIPLINEAR;
	MIPNEAREST;
	MIPNONE;
	
}


#else


#if flash
@:native("flash.display3D.Context3DMipFilter")
#end

@:fakeEnum(String) extern enum Context3DMipFilter {
	
	MIPLINEAR;
	MIPNEAREST;
	MIPNONE;
	
}


#end