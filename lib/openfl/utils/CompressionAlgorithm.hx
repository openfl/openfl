package openfl.utils;


@:enum abstract CompressionAlgorithm(String) from String to String {
	
	public var DEFLATE = "deflate";
	//GZIP;
	public var LZMA = "lzma";
	public var ZLIB = "zlib";
	
}