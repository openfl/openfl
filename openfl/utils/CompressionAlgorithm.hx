package openfl.utils; #if !openfl_legacy


@:enum abstract CompressionAlgorithm(Int) {
	
	public var DEFLATE = 0;
	//GZIP;
	public var LZMA = 1;
	public var ZLIB = 2;
	
	@:from private static inline function fromString (value:String):CompressionAlgorithm {
		
		return switch (value) {
			
			case "lzma": LZMA;
			case "zlib": ZLIB;
			default: return DEFLATE;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case CompressionAlgorithm.LZMA: "lzma";
			case CompressionAlgorithm.ZLIB: "zlib";
			default: "deflate";
			
		}
		
	}
	
}


#else
typedef CompressionAlgorithm = openfl._legacy.utils.CompressionAlgorithm;
#end