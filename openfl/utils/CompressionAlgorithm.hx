package openfl.utils; #if !openfl_legacy


@:enum abstract CompressionAlgorithm(String) from String to String {
	
	public var DEFLATE = "deflate";
	public var GZIP = "gzip";
	public var LZMA = "lzma";
	public var ZLIB = "zlib";
	
}


#else
typedef CompressionAlgorithm = openfl._legacy.utils.CompressionAlgorithm;
#end
