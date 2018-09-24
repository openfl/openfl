package openfl._internal.formats.atf;


@:enum abstract ATFFormat(Int) {
	
	public var RGB888 = 0;
	public var RGBA8888 = 1;
	public var COMPRESSED = 2; // JPEG-XR+LZMA & Block compression
	public var RAW_COMPRESSED = 3; // Block compression
	public var COMPRESSED_ALPHA = 4; // JPEG-XR+LZMA & Block compression with Alpha
	public var RAW_COMPRESSED_ALPHA = 5; // Block compression with Alpha
	
}