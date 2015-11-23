package openfl.utils;


#if flash
typedef CompressionAlgorithm = flash.utils.CompressionAlgorithm;
#elseif !openfl_legacy


enum CompressionAlgorithm {
	
	DEFLATE;
	ZLIB;
	LZMA;
	GZIP;
	
}


#else
typedef CompressionAlgorithm = openfl._legacy.utils.CompressionAlgorithm;
#end