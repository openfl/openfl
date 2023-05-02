package openfl.utils;

#if !flash

#if !openfljs
/**
	The CompressionAlgorithm class defines string constants for the names of
	compress and uncompress options. These constants are used as values of the
	`algorithm` parameter of the `ByteArray.compress()` and
	`ByteArray.uncompress()` methods.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract CompressionAlgorithm(Null<Int>)

{
	/**
		Defines the string to use for the deflate compression algorithm.
	**/
	public var DEFLATE = 0;

	// GZIP;
	public var LZMA = 1;

	/**
		Defines the string to use for the zlib compression algorithm.
	**/
	public var ZLIB = 2;

	@:from private static function fromString(value:String):CompressionAlgorithm
	{
		return switch (value)
		{
			case "deflate": DEFLATE;
			case "lzma": LZMA;
			case "zlib": ZLIB;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : CompressionAlgorithm)
		{
			case CompressionAlgorithm.DEFLATE: "deflate";
			case CompressionAlgorithm.LZMA: "lzma";
			case CompressionAlgorithm.ZLIB: "zlib";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract CompressionAlgorithm(String) from String to String

{
	public var DEFLATE = "deflate";
	// GZIP;
	public var LZMA = "lzma";
	public var ZLIB = "zlib";
}
#end
#else
typedef CompressionAlgorithm = flash.utils.CompressionAlgorithm;
#end
