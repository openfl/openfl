package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DMipFilter")
#end


@:fakeEnum(String) extern enum Context3DMipFilter {
	
	MIPLINEAR;
	MIPNEAREST;
	MIPNONE;
	
}