package openfl.display3D; #if !flash


enum Context3DTextureFormat {
	
	BGRA;
	COMPRESSED;
	COMPRESSED_ALPHA;
	
}


#else
typedef Context3DTextureFormat = flash.display3D.Context3DTextureFormat;
#end