package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DTextureFormat")
#end


@:fakeEnum(String) extern enum Context3DTextureFormat {
	
	BGRA;
	BGRA_PACKED;
	BGR_PACKED;
	COMPRESSED;
	COMPRESSED_ALPHA;
	RGBA_HALF_FLOAT;
	
}