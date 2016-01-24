package openfl.utils;


#if flash
@:native("flash.utils.CompressionAlgorithm")
@:require(flash11)
#end

@:enum abstract CompressionAlgorithm(String) from String to String {
	
	public var DEFLATE = "deflate";
	//GZIP;
	public var LZMA = "lzma";
	public var ZLIB = "zlib";
	
}