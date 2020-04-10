/**
	An enum containing different pixel encoding formats for image data
**/
export enum PixelFormat
{
	/**
		An image encoded in 32-bit RGBA color order
	**/
	RGBA32 = 0,

	/**
		An image encoded in 32-bit ARGB color order
	**/
	ARGB32 = 1,

	/**
		An image encoded in 32-bit BGRA color order
	**/
	BGRA32 = 2
}

export default PixelFormat;
