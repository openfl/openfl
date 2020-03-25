namespace openfl._internal.formats.atf;

@: enum abstract ATFFormat(Int)
{
	public RGB888 = 0;
	public RGBA8888 = 1;
	public COMPRESSED = 2; // JPEG-XR+LZMA & Block compression
	public RAW_COMPRESSED = 3; // Block compression
	public COMPRESSED_ALPHA = 4; // JPEG-XR+LZMA & Block compression with Alpha
	public RAW_COMPRESSED_ALPHA = 5; // Block compression with Alpha
}
