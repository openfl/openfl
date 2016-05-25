package openfl.display3D;


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