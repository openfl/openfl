package openfl.utils;


#if flash
@:native("flash.utils.CompressionAlgorithm")
@:require(flash11)
#end


@:fakeEnum(String) extern enum CompressionAlgorithm {
	
	DEFLATE;
	LZMA;
	ZLIB;
	
}