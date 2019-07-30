package openfl.utils; #if (display || !flash)


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
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case CompressionAlgorithm.DEFLATE: "deflate";
			case CompressionAlgorithm.LZMA: "lzma";
			case CompressionAlgorithm.ZLIB: "zlib";
			default: null;
			
		}
		
	}
	
}


#else
typedef CompressionAlgorithm = flash.utils.CompressionAlgorithm;
#end