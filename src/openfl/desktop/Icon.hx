package openfl.desktop;

#if (!flash && sys)
import openfl.display.BitmapData;
import openfl.events.EventDispatcher;

/**
	The Icon class represents an operating system icon.

	An Icon object has one property, `bitmaps`, which is an array of BitmapData
	objects. Only one image is displayed at a time. The operating system selects
	the image closest in size to the icon's current display size, scaling if
	necessary.
**/
class Icon extends EventDispatcher
{
	public function new()
	{
		super();
	}

	/**
		The icon image as an array of BitmapData objects of different sizes.

		When an icon is displayed in a given operating system context, the
		bitmap in the array closest to the displayed size is used (and scaled
		if necessary). Common sizes include 16x16, 32x32, 48x48, and 128x128.
		(512x512 pixel icons may be used for some operating system icons in the
		near future.)

		In some contexts, the operating system may use a default system icon if
		nothing has been assigned to the bitmaps property. In other contexts, no
		icon appears.

		To set or change the icon appearance, assign an array of BitmapData
		objects to the `bitmaps` property:

		```haxe
		icon.bitmaps = new Array(icon16x16.bitmapData, icon128x128.bitmapData);
		```

		Modifying the bitmaps array directly has no effect.

		To clear the icon image, assign an empty array to the `bitmaps` property.

		Note: When loading image files for an icon, the PNG file format
		generally provides the best alpha blending. The GIF format supports only
		on or off transparency (no blending). The JPG format does not support
		transparency at all.
	**/
	public var bitmaps:Array<BitmapData> = [];
}
#else
#if air
typedef Icon = flash.desktop.Icon;
#end
#end
