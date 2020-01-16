package openfl._internal.backend.lime_standalone;

/**
	An enum containing values for the underlying image type
	represented by an `ImageBuffer`
**/
enum ImageType
{
	/**
		The source image data is stored in a `js.html.Image` or `js.html.CanvasElement`
	**/
	CANVAS;

	/**
		The source image data is stored in a `UInt8Array`
	**/
	DATA;

	/**
		The source image data is stored in a `flash.display.BitmapData`
	**/
	FLASH;

	/**
		The source image data is stored in a custom format
	**/
	CUSTOM;
}
