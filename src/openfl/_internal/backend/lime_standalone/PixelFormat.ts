namespace openfl._internal.backend.lime_standalone;

/**
	An enum containing different pixel encoding formats for image data
**/
@: enum abstract PixelFormat(Int) from Int to Int from UInt to UInt
{
	/**
		An image encoded in 32-bit RGBA color order
	**/
	public RGBA32 = 0;

	/**
		An image encoded in 32-bit ARGB color order
	**/
	public ARGB32 = 1;

	/**
		An image encoded in 32-bit BGRA color order
	**/
	public BGRA32 = 2;
}
