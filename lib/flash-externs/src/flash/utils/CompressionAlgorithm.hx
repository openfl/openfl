package flash.utils;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract CompressionAlgorithm(String) from String to String

{
	public var DEFLATE = "deflate";
	// GZIP;
	public var LZMA = "lzma";
	public var ZLIB = "zlib";
}
#else
typedef CompressionAlgorithm = openfl.utils.CompressionAlgorithm;
#end
