package openfl.display3D; #if !flash


enum Context3DTextureFilter {
	
	ANISOTROPIC2X;
	ANISOTROPIC4X;
	ANISOTROPIC8X;
	ANISOTROPIC16X;
	LINEAR;
	NEAREST;
	
}


#else
typedef Context3DTextureFilter = flash.display3D.Context3DTextureFilter;
#end