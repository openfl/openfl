export enum ATFFormat
{
	RGB888 = 0,
	RGBA8888 = 1,
	COMPRESSED = 2, // JPEG-XR+LZMA & Block compression
	RAW_COMPRESSED = 3, // Block compression
	COMPRESSED_ALPHA = 4, // JPEG-XR+LZMA & Block compression with Alpha
	RAW_COMPRESSED_ALPHA = 5 // Block compression with Alpha
}

export default ATFFormat;
