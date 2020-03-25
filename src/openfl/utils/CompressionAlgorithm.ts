
/**
	The CompressionAlgorithm class defines string constants for the names of
	compress and uncompress options. These constants are used as values of the
	`algorithm` parameter of the `ByteArray.compress()` and
	`ByteArray.uncompress()` methods.
**/
export enum CompressionAlgorithm
{
	/**
		Defines the string to use for the deflate compression algorithm.
	**/
	DEFLATE = "deflate",

	// GZIP;
	LZMA = "lzma",

	/**
		Defines the string to use for the zlib compression algorithm.
	**/
	ZLIB = "zlib"
}

export default CompressionAlgorithm;
