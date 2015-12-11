package openfl.utils; #if !openfl_legacy


enum CompressionAlgorithm {
	
	DEFLATE;
	ZLIB;
	LZMA;
	GZIP;
	
}


#else
typedef CompressionAlgorithm = openfl._legacy.utils.CompressionAlgorithm;
#end