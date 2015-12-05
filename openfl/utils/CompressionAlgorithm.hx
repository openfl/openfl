package openfl.utils; #if (!display && !flash) #if !openfl_legacy


enum CompressionAlgorithm {
	
	DEFLATE;
	ZLIB;
	LZMA;
	GZIP;
	
}


#else
typedef CompressionAlgorithm = openfl._legacy.utils.CompressionAlgorithm;
#end
#else


#if flash
@:native("flash.utils.CompressionAlgorithm")
@:require(flash11)
#end


@:fakeEnum(String) extern enum CompressionAlgorithm {
	
	DEFLATE;
	LZMA;
	ZLIB;
	
}


#end