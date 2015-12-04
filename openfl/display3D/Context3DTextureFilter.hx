package openfl.display3D; #if (!display && !flash)


enum Context3DTextureFilter {
	
	ANISOTROPIC2X;
	ANISOTROPIC4X;
	ANISOTROPIC8X;
	ANISOTROPIC16X;
	LINEAR;
	NEAREST;
	
}


#else


#if flash
@:native("flash.display3D.Context3DTextureFilter")
#end

@:fakeEnum(String) extern enum Context3DTextureFilter {
	
	ANISOTROPIC16X;
	ANISOTROPIC2X;
	ANISOTROPIC4X;
	ANISOTROPIC8X;
	LINEAR;
	NEAREST;
	
}


#end