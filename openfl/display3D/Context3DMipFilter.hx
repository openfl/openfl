package openfl.display3D; #if !flash


enum Context3DMipFilter {
	
	MIPLINEAR;
	MIPNEAREST;
	MIPNONE;

}


#else
typedef Context3DMipFilter = flash.display3D.Context3DMipFilter;
#end