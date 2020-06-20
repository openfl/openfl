package openfl.filters;

#if (display || !flash)
/**
	The ColorMatrixFilter class lets you apply a 4 x 5 matrix transformation
	on the RGBA color and alpha values of every pixel in the input image to
	produce a result with a new set of RGBA color and alpha values. It allows
	saturation changes, hue rotation, luminance to alpha, and various other
	effects. You can apply the filter to any display object (that is, objects
	that inherit from the DisplayObject class), such as MovieClip,
	SimpleButton, TextField, and Video objects, as well as to BitmapData
	objects.
	**Note:** For RGBA values, the most significant byte represents the red
	channel value, followed by green, blue, and then alpha.

	To create a new color matrix filter, use the syntax `new
	ColorMatrixFilter()`. The use of filters depends on the object to which
	you apply the filter:

	* To apply filters to movie clips, text fields, buttons, and video, use
	the `filters` property (inherited from DisplayObject). Setting the
	`filters` property of an object does not modify the object, and you can
	remove the filter by clearing the `filters` property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling `applyFilter()` on a BitmapData
	object takes the source BitmapData object and the filter object and
	generates a filtered image as a result.

	If you apply a filter to a display object, the `cacheAsBitmap` property of
	the display object is set to `true`. If you remove all filters, the
	original value of `cacheAsBitmap` is restored.

	A filter is not applied if the resulting image exceeds the maximum
	dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
	width or height, and the total number of pixels cannot exceed 16,777,215
	pixels. (So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
	high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
	limitation is 2,880 pixels in height and 2,880 pixels in width. For
	example, if you zoom in on a large movie clip with a filter applied, the
	filter is turned off if the resulting image reaches the maximum
	dimensions.
**/
@:jsRequire("openfl/filters/ColorMatrixFilter", "default")
@:final extern class ColorMatrixFilter extends BitmapFilter
{
	/**
		An array of 20 items for 4 x 5 color transform. The `matrix` property
		cannot be changed by directly modifying its value (for example,
		`myFilter.matrix[2] = 1;`). Instead, you must get a reference to the
		array, make the change to the reference, and reset the value.
		The color matrix filter separates each source pixel into its red,
		green, blue, and alpha components as srcR, srcG, srcB, srcA. To
		calculate the result of each of the four channels, the value of each
		pixel in the image is multiplied by the values in the transformation
		matrix. An offset, between -255 and 255, can optionally be added to
		each result (the fifth item in each row of the matrix). The filter
		combines each color component back into a single pixel and writes out
		the result. In the following formula, a[0] through a[19] correspond to
		entries 0 through 19 in the 20-item array that is passed to the
		`matrix` property:

		```
		redResult   = (a[0]  * srcR) + (a[1]  * srcG) + (a[2]  * srcB) + (a[3]  * srcA) + a[4]
		greenResult = (a[5]  * srcR) + (a[6]  * srcG) + (a[7]  * srcB) + (a[8]  * srcA) + a[9]
		blueResult  = (a[10] * srcR) + (a[11] * srcG) + (a[12] * srcB) + (a[13] * srcA) + a[14]
		alphaResult = (a[15] * srcR) + (a[16] * srcG) + (a[17] * srcB) + (a[18] * srcA) + a[19]
		```

		For each color value in the array, a value of 1 is equal to 100% of
		that channel being sent to the output, preserving the value of the
		color channel.

		The calculations are performed on unmultiplied color values. If the
		input graphic consists of premultiplied color values, those values are
		automatically converted into unmultiplied color values for this
		operation.

		Two optimized modes are available:

		**Alpha only.** When you pass to the filter a matrix that adjusts only
		the alpha component, as shown here, the filter optimizes its
		performance:

		```
		1 0 0 0 0
		0 1 0 0 0
		0 0 1 0 0
		0 0 0 N 0  (where N is between 0.0 and 1.0)
		```

		**Faster version**. Available only with SSE/AltiVec
		accelerator-enabled processors, such as Intel<sup>®</sup>
		Pentium<sup>®</sup> 3 and later and Apple<sup>®</sup> G4 and later.
		The accelerator is used when the multiplier terms are in the range
		-15.99 to 15.99 and the adder terms a[4], a[9], a[14], and a[19] are
		in the range -8000 to 8000.

		@throws TypeError The Array is `null` when being set
	**/
	public var matrix(default, set):Array<Float>;
	
	/**
		Initializes a new ColorMatrixFilter instance with the specified
		parameters.
	**/
	public function new(matrix:Array<Float> = null);
}
#else
typedef ColorMatrixFilter = flash.filters.ColorMatrixFilter;
#end
