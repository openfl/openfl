package flash.utils;

@:fakeEnum(String) @:require(flash11) extern enum CompressionAlgorithm {
	DEFLATE;
	LZMA;
	ZLIB;
	GZIP; // Not available in Flash Player
}
