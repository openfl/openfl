package openfl.utils; #if !openfljs


@:enum abstract CompressionAlgorithm(Null<Int>) {
	
	public var DEFLATE = 0;
	//GZIP;
	public var LZMA = 1;
	public var ZLIB = 2;
	
	@:from private static function fromString (value:String):CompressionAlgorithm {
		
		return switch (value) {
			
			case "deflate": DEFLATE;
			case "lzma": LZMA;
			case "zlib": ZLIB;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case CompressionAlgorithm.DEFLATE: "deflate";
			case CompressionAlgorithm.LZMA: "lzma";
			case CompressionAlgorithm.ZLIB: "zlib";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract CompressionAlgorithm(String) from String to String {
	
	public var DEFLATE = "deflate";
	//GZIP;
	public var LZMA = "lzma";
	public var ZLIB = "zlib";
	
}


#end