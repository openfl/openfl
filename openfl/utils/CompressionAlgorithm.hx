package openfl.utils; #if !flash


enum CompressionAlgorithm {
	
	DEFLATE;
	ZLIB;
	LZMA;
	GZIP;
	
}


#else
typedef CompressionAlgorithm = flash.utils.CompressionAlgorithm;
#end