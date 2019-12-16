package flash.utils;

#if flash
@:enum abstract CompressionAlgorithm(String) from String to String
{
	public var DEFLATE = "deflate";
	// GZIP;
	public var LZMA = "lzma";
	public var ZLIB = "zlib";
}
#else
typedef CompressionAlgorithm = openfl.utils.CompressionAlgorithm;
#end
