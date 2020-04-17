// import Context3DRenderer from "../_internal/renderer/context3D/Context3DRenderer";
import BitmapDataPool from "../_internal/renderer/BitmapDataPool";
import DisplayObjectRenderData from "../_internal/renderer/DisplayObjectRenderData";
import DisplayObjectType from "../_internal/renderer/DisplayObjectType";
import * as internal from "../_internal/utils/InternalAccess";
import BitmapDataChannel from "../display/BitmapDataChannel";
import BlendMode from "../display/BlendMode";
import DisplayObject from "../display/DisplayObject";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import IBitmapDrawable from "../display/IBitmapDrawable";
import StageQuality from "../display/StageQuality";
import TextureBase from "../display3D/textures/TextureBase";
// import Context3D from "../display3D/Context3D";
// import IndexBuffer3D from "../display3D/IndexBuffer3D";
// import VertexBuffer3D from "../display3D/VertexBuffer3D";
import Error from "../errors/Error";
import BitmapFilter from "../filters/BitmapFilter";
import ColorTransform from "../geom/ColorTransform";
import Matrix from "../geom/Matrix";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
import ByteArray from "../utils/ByteArray";
import Future from "../utils/Future";
import Vector from "../Vector";

/**
	The BitmapData class lets you work with the data (pixels) of a Bitmap
	object. You can use the methods of the BitmapData class to create
	arbitrarily sized transparent or opaque bitmap images and manipulate them
	in various ways at runtime. You can also access the BitmapData for a bitmap
	image that you load with the `openfl.Assets` or
	`openfl.display.Loader` classes.

	This class lets you separate bitmap rendering operations from the
	internal display updating routines of OpenFL. By manipulating a
	BitmapData object directly, you can create complex images without incurring
	the per-frame overhead of constantly redrawing the content from vector
	data.

	The methods of the BitmapData class support effects that are not
	available through the filters available to non-bitmap display objects.

	A BitmapData object contains an array of pixel data. This data can
	represent either a fully opaque bitmap or a transparent bitmap that
	contains alpha channel data. Either type of BitmapData object is stored as
	a buffer of 32-bit integers. Each 32-bit integer determines the properties
	of a single pixel in the bitmap.

	Each 32-bit integer is a combination of four 8-bit channel values (from
	0 to 255) that describe the alpha transparency and the red, green, and blue
	(ARGB) values of the pixel. (For ARGB values, the most significant byte
	represents the alpha channel value, followed by red, green, and blue.)

	The four channels (alpha, red, green, and blue) are represented as
	numbers when you use them with the `BitmapData.copyChannel()`
	method or the `DisplacementMapFilter.componentX` and
	`DisplacementMapFilter.componentY` properties, and these numbers
	are represented by the following constants in the BitmapDataChannel
	class:

	* `BitmapDataChannel.ALPHA`
	* `BitmapDataChannel.RED`
	* `BitmapDataChannel.GREEN`
	* `BitmapDataChannel.BLUE`

	You can attach BitmapData objects to a Bitmap object by using the
	`bitmapData` property of the Bitmap object.

	You can use a BitmapData object to fill a Graphics object by using the
	`Graphics.beginBitmapFill()` method.

	You can also use a BitmapData object to perform batch tile rendering
	using the `openfl.display.Tilemap` class.

	In Flash Player 10, the maximum size for a BitmapData object
	is 8,191 pixels in width or height, and the total number of pixels cannot
	exceed 16,777,215 pixels. (So, if a BitmapData object is 8,191 pixels wide,
	it can only be 2,048 pixels high.) In Flash Player 9 and earlier, the limitation
	is 2,880 pixels in height and 2,880 in width.
**/
export default class BitmapData implements IBitmapDrawable
{
	// protected static __hardwareRenderer: Context3DRenderer;
	protected static __pool: BitmapDataPool = new BitmapDataPool();
	protected static __softwareRenderer: DisplayObjectRenderer;
	protected static __textureFormat: number;
	protected static __textureInternalFormat: number;
	protected static __tempVector: Point = new Point();

	protected __blendMode: BlendMode;
	protected __height: number;
	protected __isMask: boolean;
	protected __isValid: boolean;
	protected __mask: DisplayObject;
	protected __readable: boolean;
	protected __rect: Rectangle;
	protected __renderable: boolean;
	protected __renderData: DisplayObjectRenderData;
	protected __renderTransform: Matrix;
	protected __scrollRect: Rectangle;
	protected __transform: Matrix;
	protected __transparent: boolean;
	protected __type: DisplayObjectType;
	protected __width: number;
	protected __worldAlpha: number;
	protected __worldColorTransform: ColorTransform;
	protected __worldTransform: Matrix;

	/**
		Creates a BitmapData object with a specified width and height. If you specify a value for
		the `fillColor` parameter, every pixel in the bitmap is set to that color.

		By default, the bitmap is created as transparent, unless you pass the value `false`
		for the transparent parameter. After you create an opaque bitmap, you cannot change it
		to a transparent bitmap. Every pixel in an opaque bitmap uses only 24 bits of color channel
		information. If you define the bitmap as transparent, every pixel uses 32 bits of color
		channel information, including an alpha transparency channel.

		@param	width		The width of the bitmap image in pixels.
		@param	height		The height of the bitmap image in pixels.
		@param	transparent		Specifies whether the bitmap image supports per-pixel transparency. The default value is `true`(transparent). To create a fully transparent bitmap, set the value of the `transparent` parameter to `true` and the value of the `fillColor` parameter to 0x00000000(or to 0). Setting the `transparent` property to `false` can result in minor improvements in rendering performance.
		@param	fillColor		A 32-bit ARGB color value that you use to fill the bitmap image area. The default value is 0xFFFFFFFF(solid white).
	**/
	public constructor(width: number, height: number, transparent: boolean = true, fillColor: number = 0xFFFFFFFF)
	{
		this.__transparent = transparent;

		width = width == null ? 0 : width;
		height = height == null ? 0 : height;

		width = width < 0 ? 0 : width;
		height = height < 0 ? 0 : height;

		this.__width = width;
		this.__height = height;
		this.__rect = new Rectangle(0, 0, width, height);

		this.__renderData = new DisplayObjectRenderData();
		this.__renderTransform = new Matrix();
		this.__worldAlpha = 1;
		this.__worldTransform = new Matrix();
		this.__worldColorTransform = new ColorTransform();
		this.__renderable = true;

		// __backend = new BitmapDataBackend(this, width, height, transparent, fillColor);
	}

	/**
		Takes a source image and a filter object and generates the filtered image.

		This method relies on the behavior of built-in filter objects, which determine the
		destination rectangle that is affected by an input source rectangle.

		After a filter is applied, the resulting image can be larger than the input image.
		For example, if you use a BlurFilter class to blur a source rectangle of(50,50,100,100)
		and a destination point of(10,10), the area that changes in the destination image is
		larger than(10,10,60,60) because of the blurring. This happens internally during the
		applyFilter() call.

		If the `sourceRect` parameter of the sourceBitmapData parameter is an
		interior region, such as(50,50,100,100) in a 200 x 200 image, the filter uses the source
		pixels outside the `sourceRect` parameter to generate the destination rectangle.

		If the BitmapData object and the object specified as the `sourceBitmapData`
		parameter are the same object, the application uses a temporary copy of the object to
		perform the filter. For best performance, avoid this situation.

		@param	sourceBitmapData		The input bitmap image to use. The source image can be a different BitmapData object or it can refer to the current BitmapData instance.
		@param	sourceRect		A rectangle that defines the area of the source image to use as input.
		@param	destPoint		The point within the destination image(the current BitmapData instance) that corresponds to the upper-left corner of the source rectangle.
		@param	filter		The filter object that you use to perform the filtering operation.
	**/
	public applyFilter(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, filter: BitmapFilter): void
	{
		if (!this.readable || sourceBitmapData == null || !sourceBitmapData.readable) return;
		// __backend.applyFilter(sourceBitmapData, sourceRect, destPoint, filter);
	}

	/**
		Returns a new BitmapData object that is a clone of the original instance with an exact copy of the contained bitmap.
		@return		A new BitmapData object that is identical to the original.
	**/
	public clone(): BitmapData
	{
		// return __backend.clone();
		return null;
	}

	/**
		Adjusts the color values in a specified area of a bitmap image by using a `ColorTransform`
		object. If the rectangle matches the boundaries of the bitmap image, this method transforms the color
		values of the entire image.
		@param	rect		A Rectangle object that defines the area of the image in which the ColorTransform object is applied.
		@param	colorTransform		A ColorTransform object that describes the color transformation values to apply.
	**/
	public colorTransform(rect: Rectangle, colorTransform: ColorTransform): void
	{
		if (!this.readable) return;
		// __backend.colorTransform(rect, colorTransform);
	}

	/**
		Compares two BitmapData objects. If the two BitmapData objects have the same dimensions (width and height), the method returns a new BitmapData object, in which each pixel is the "difference" between the pixels in the two source objects:

		- If two pixels are equal, the difference pixel is 0x00000000.
		- If two pixels have different RGB values (ignoring the alpha value), the difference pixel is 0xFFRRGGBB where RR/GG/BB are the individual difference values between red, green, and blue channels. Alpha channel differences are ignored in this case.
		- If only the alpha channel value is different, the pixel value is 0xZZFFFFFF, where ZZ is the difference in the alpha value.

		@param	otherBitmapData The BitmapData object to compare with the source BitmapData object.
		@return If the two BitmapData objects have the same dimensions (width and height), the method returns a new BitmapData object that has the difference between the two objects (see the main discussion).If the BitmapData objects are equivalent, the method returns the number 0. If no argument is passed or if the argument is not a BitmapData object, the method returns -1. If either BitmapData object has been disposed of, the method returns -2. If the widths of the BitmapData objects are not equal, the method returns the number -3. If the heights of the BitmapData objects are not equal, the method returns the number -4.
	**/
	public compare(otherBitmapData: BitmapData): BitmapData | number
	{
		if (otherBitmapData == this)
		{
			return 0;
		}
		else if (otherBitmapData == null)
		{
			return -1;
		}
		else if (this.readable == false || otherBitmapData.readable == false)
		{
			return -2;
		}
		else if (this.__width != otherBitmapData.width)
		{
			return -3;
		}
		else if (this.__height != otherBitmapData.height)
		{
			return -4;
		}

		// return __backend.compare(otherBitmapData);
		return null;
	}

	/**
		Transfers data from one channel of another BitmapData object or the
		current BitmapData object into a channel of the current BitmapData object.
		All of the data in the other channels in the destination BitmapData object
		are preserved.

		The source channel value and destination channel value can be one of
		following values:

		* `BitmapDataChannel.RED`
		* `BitmapDataChannel.GREEN`
		* `BitmapDataChannel.BLUE`
		* `BitmapDataChannel.ALPHA`


		@param sourceBitmapData The input bitmap image to use. The source image
								can be a different BitmapData object or it can
								refer to the current BitmapData object.
		@param sourceRect       The source Rectangle object. To copy only channel
								data from a smaller area within the bitmap,
								specify a source rectangle that is smaller than
								the overall size of the BitmapData object.
		@param destPoint        The destination Point object that represents the
								upper-left corner of the rectangular area where
								the new channel data is placed. To copy only
								channel data from one area to a different area in
								the destination image, specify a point other than
							   (0,0).
		@param sourceChannel    The source channel. Use a value from the
								BitmapDataChannel class
							   (`BitmapDataChannel.RED`,
								`BitmapDataChannel.BLUE`,
								`BitmapDataChannel.GREEN`,
								`BitmapDataChannel.ALPHA`).
		@param destChannel      The destination channel. Use a value from the
								BitmapDataChannel class
							   (`BitmapDataChannel.RED`,
								`BitmapDataChannel.BLUE`,
								`BitmapDataChannel.GREEN`,
								`BitmapDataChannel.ALPHA`).
		@throws TypeError The sourceBitmapData, sourceRect or destPoint are null.
	**/
	public copyChannel(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, sourceChannel: BitmapDataChannel,
		destChannel: BitmapDataChannel): void
	{
		if (!this.readable) return;
		// __backend.copyChannel(sourceBitmapData, sourceRect, destPoint, sourceChannel, destChannel);
	}

	/**
		Provides a fast routine to perform pixel manipulation between images with
		no stretching, rotation, or color effects. This method copies a
		rectangular area of a source image to a rectangular area of the same size
		at the destination point of the destination BitmapData object.

		If you include the `alphaBitmap` and `alphaPoint`
		parameters, you can use a secondary image as an alpha source for the
		source image. If the source image has alpha data, both sets of alpha data
		are used to composite pixels from the source image to the destination
		image. The `alphaPoint` parameter is the point in the alpha
		image that corresponds to the upper-left corner of the source rectangle.
		Any pixels outside the intersection of the source image and alpha image
		are not copied to the destination image.

		The `mergeAlpha` property controls whether or not the alpha
		channel is used when a transparent image is copied onto another
		transparent image. To copy pixels with the alpha channel data, set the
		`mergeAlpha` property to `true`. By default, the
		`mergeAlpha` property is `false`.

		@param sourceBitmapData The input bitmap image from which to copy pixels.
								The source image can be a different BitmapData
								instance, or it can refer to the current
								BitmapData instance.
		@param sourceRect       A rectangle that defines the area of the source
								image to use as input.
		@param destPoint        The destination point that represents the
								upper-left corner of the rectangular area where
								the new pixels are placed.
		@param alphaBitmapData  A secondary, alpha BitmapData object source.
		@param alphaPoint       The point in the alpha BitmapData object source
								that corresponds to the upper-left corner of the
								`sourceRect` parameter.
		@param mergeAlpha       To use the alpha channel, set the value to
								`true`. To copy pixels with no alpha
								channel, set the value to `false`.
		@throws TypeError The sourceBitmapData, sourceRect, destPoint are null.
	**/
	public copyPixels(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, alphaBitmapData: BitmapData = null, alphaPoint: Point = null,
		mergeAlpha: boolean = false): void
	{
		if (!this.readable || sourceBitmapData == null) return;
		// __backend.copyPixels(sourceBitmapData, sourceRect, destPoint, alphaBitmapData, alphaPoint, mergeAlpha);
	}

	// /** @hidden */ @:dox(hide) @:require(flash11_4) public copyPixelsToByteArray (rect:Rectangle, data:ByteArray):Void;

	/**
		Frees memory that is used to store the BitmapData object.

		When the `dispose()` method is called on an image, the width
		and height of the image are set to 0. All subsequent calls to methods or
		properties of this BitmapData instance fail, and an exception is thrown.


		`BitmapData.dispose()` releases the memory occupied by the
		actual bitmap data, immediately(a bitmap can consume up to 64 MB of
		memory). After using `BitmapData.dispose()`, the BitmapData
		object is no longer usable and an exception may be thrown if
		you call functions on the BitmapData object. However,
		`BitmapData.dispose()` does not garbage collect the BitmapData
		object(approximately 128 bytes); the memory occupied by the actual
		BitmapData object is released at the time the BitmapData object is
		collected by the garbage collector.

	**/
	public dispose(): void
	{
		this.__width = 0;
		this.__height = 0;
		this.__rect = null;
		this.__readable = false;

		// __backend.dispose();
	}

	/**
		Frees the backing Lime image buffer, if possible.

		When using a software renderer, such as Flash Player or desktop targets
		without OpenGL, the software buffer will be retained so that the BitmapData
		will work properly. When using a hardware renderer, the Lime image
		buffer will be available to garbage collection after a hardware texture
		has been created internally.

		`BitmapData.disposeImage()` will immediately change the value of
		the `readable` property to `false`.
	**/
	public disposeImage(): void
	{
		// __backend.disposeImage();
	}

	/**
		Draws the `source` display object onto the bitmap image, using
		the OpenFL software renderer. You can specify `matrix`,
		`colorTransform`, `blendMode`, and a destination
		`clipRect` parameter to control how the rendering performs.
		Optionally, you can specify whether the bitmap should be smoothed when
		scaled(this works only if the source object is a BitmapData object).

		The source display object does not use any of its applied
		transformations for this call. It is treated as it exists in the library
		or file, with no matrix transform, no color transform, and no blend mode.
		To draw a display object(such as a movie clip) by using its own transform
		properties, you can copy its `transform` property object to the
		`transform` property of the Bitmap object that uses the
		BitmapData object.

		@param source         The display object or BitmapData object to draw to
							  the BitmapData object.(The DisplayObject and
							  BitmapData classes implement the IBitmapDrawable
							  interface.)
		@param matrix         A Matrix object used to scale, rotate, or translate
							  the coordinates of the bitmap. If you do not want to
							  apply a matrix transformation to the image, set this
							  parameter to an identity matrix, created with the
							  default `new Matrix()` constructor, or
							  pass a `null` value.
		@param colorTransform A ColorTransform object that you use to adjust the
							  color values of the bitmap. If no object is
							  supplied, the bitmap image's colors are not
							  transformed. If you must pass this parameter but you
							  do not want to transform the image, set this
							  parameter to a ColorTransform object created with
							  the default `new ColorTransform()`
							  constructor.
		@param blendMode      A string value, from the openfl.display.BlendMode
							  class, specifying the blend mode to be applied to
							  the resulting bitmap.
		@param clipRect       A Rectangle object that defines the area of the
							  source object to draw. If you do not supply this
							  value, no clipping occurs and the entire source
							  object is drawn.
		@param smoothing      A Boolean value that determines whether a BitmapData
							  object is smoothed when scaled or rotated, due to a
							  scaling or rotation in the `matrix`
							  parameter. The `smoothing` parameter only
							  applies if the `source` parameter is a
							  BitmapData object. With `smoothing` set
							  to `false`, the rotated or scaled
							  BitmapData image can appear pixelated or jagged. For
							  example, the following two images use the same
							  BitmapData object for the `source`
							  parameter, but the `smoothing` parameter
							  is set to `true` on the left and
							  `false` on the right:

							  ![Two images: the left one with smoothing and the right one without smoothing.](/images/bitmapData_draw_smoothing.jpg)

							  Drawing a bitmap with `smoothing` set
							  to `true` takes longer than doing so with
							  `smoothing` set to
							  `false`.
		@throws ArgumentError The `source` parameter is not a
							  BitmapData or DisplayObject object.
		@throws ArgumentError The source is null or not a valid IBitmapDrawable
							  object.
		@throws SecurityError The `source` object and(in the case of a
							  Sprite or MovieClip object) all of its child objects
							  do not come from the same domain as the caller, or
							  are not in a content that is accessible to the
							  caller by having called the
							  `Security.allowDomain()` method. This
							  restriction does not apply to AIR content in the
							  application security sandbox.
	**/
	public draw(source: IBitmapDrawable, matrix: Matrix = null, colorTransform: ColorTransform = null, blendMode: BlendMode = null,
		clipRect: Rectangle = null, smoothing: boolean = false): void
	{
		if (source == null) return;

		(<internal.DisplayObject><any>source).__update(false, true);

		var transform = (<internal.Matrix><any>Matrix).__pool.get();

		transform.copyFrom((<internal.DisplayObject><any>source).__renderTransform);
		transform.invert();

		if (matrix != null)
		{
			transform.concat(matrix);
		}

		// __backend.draw(source, transform, colorTransform, blendMode, clipRect, smoothing);

		(<internal.Matrix><any>Matrix).__pool.release(transform);
	}

	/**
		Draws the `source` display object onto the bitmap image, using the Flash runtime
		vector renderer. You can specify `matrix`, `colorTransform`, `blendMode`, and a
		destination `clipRect` parameter to control how the rendering performs.
		Optionally, you can specify whether the bitmap should be smoothed when scaled
		(this works only if the source object is a BitmapData object).

		**Note:** The `drawWithQuality()` method works exactly like the `draw()` method,
		but instead of using the `Stage.quality` property to determine the quality of
		vector rendering, you specify the `quality` parameter to the `drawWithQuality()`
		method.

		This method directly corresponds to how objects are drawn with the standard
		vector renderer for objects in the authoring tool interface.

		The source display object does not use any of its applied transformations for
		this call. It is treated as it exists in the library or file, with no matrix
		transform, no color transform, and no blend mode. To draw a display object
		(such as a movie clip) by using its own transform properties, you can copy its
		`transform` property object to the `transform` property of the Bitmap object that
		uses the BitmapData object.

		This method is supported over RTMP in Flash Player 9.0.115.0 and later and in
		Adobe AIR. You can control access to streams on Flash Media Server in a
		server-side script. For more information, see the `Client.audioSampleAccess` and
		`Client.videoSampleAccess` properties in Server-Side ActionScript Language
		Reference for Adobe Flash Media Server.

		If the source object and (in the case of a Sprite or MovieClip object) all of
		its child objects do not come from the same domain as the caller, or are not in
		a content that is accessible to the caller by having called the
		`Security.allowDomain()` method, a call to the `drawWithQuality()` throws a
		SecurityError exception. This restriction does not apply to AIR content in the
		application security sandbox.

		There are also restrictions on using a loaded bitmap image as the source. A call
		to the `drawWithQuality()` method is successful if the loaded image comes from the
		same domain as the caller. Also, a cross-domain policy file on the image's server
		can grant permission to the domain of the SWF content calling the
		`drawWithQuality()` method. In this case, you must set the `checkPolicyFile` property
		of a LoaderContext object, and use this object as the `context` parameter when
		calling the `load()` method of the Loader object used to load the image. These
		restrictions do not apply to AIR content in the application security sandbox.

		On Windows, the `drawWithQuality()` method cannot capture SWF content embedded in an
		HTML page in an HTMLLoader object in Adobe AIR.

		The `drawWithQuality()` method cannot capture PDF content in Adobe AIR. Nor can it
		capture or SWF content embedded in HTML in which the `wmode` attribute is set to
		`"window"` in Adobe AIR.

		@param	source	The display object or BitmapData object to draw to the BitmapData
		object. (The DisplayObject and BitmapData classes implement the IBitmapDrawable
		interface.)
		@param	matrix	A Matrix object used to scale, rotate, or translate the coordinates
		of the bitmap. If you do not want to apply a matrix transformation to the image,
		set this parameter to an identity matrix, created with the default `new Matrix()`
		constructor, or pass a `null` value.
		@param	colorTransform	A ColorTransform object that you use to adjust the color
		values of the bitmap. If no object is supplied, the bitmap image's colors are not
		transformed. If you must pass this parameter but you do not want to transform the
		image, set this parameter to a ColorTransform object created with the default
		`new ColorTransform()` constructor.
		@param	blendMode	A string value, from the flash.display.BlendMode class,
		specifying the blend mode to be applied to the resulting bitmap.
		@param	clipRect	A Rectangle object that defines the area of the source object
		to draw. If you do not supply this value, no clipping occurs and the entire source
		object is drawn.
		@param	smoothing	A Boolean value that determines whether a BitmapData object is
		smoothed when scaled or rotated, due to a scaling or rotation in the `matrix`
		parameter. The smoothing parameter only applies if the `source` parameter is a
		BitmapData object. With `smoothing` set to `false`, the rotated or scaled BitmapData
		image can appear pixelated or jagged. For example, the following two images use the
		same BitmapData object for the `source` parameter, but the `smoothing` parameter is
		set to `true` on the left and `false` on the right:
		![Two images: the left one with smoothing and the right one without smoothing.](/images/bitmapData_draw_smoothing.jpg)
		Drawing a bitmap with `smoothing` set to `true` takes longer than doing so with
		`smoothing` set to `false`.
		@param	quality	Any of one of the StageQuality values. Selects the antialiasing
		quality to be used when drawing vectors graphics.
		@throws	ArgumentError	The source parameter is not a BitmapData or DisplayObject
		object.
		@throws	SecurityError	The source object and (in the case of a Sprite or MovieClip
		object) all of its child objects do not come from the same domain as the caller,
		or are not in a content that is accessible to the caller by having called the
		`Security.allowDomain()` method. This restriction does not apply to AIR content
		in the application security sandbox.
		@throws	ArgumentError	The source is `null` or not a valid IBitmapDrawable object.
	**/
	public drawWithQuality(source: IBitmapDrawable, matrix: Matrix = null, colorTransform: ColorTransform = null, blendMode: BlendMode = null,
		clipRect: Rectangle = null, smoothing: boolean = false, quality: StageQuality = null): void
	{
		// __backend.drawWithQuality(source, matrix, colorTransform, blendMode, clipRect, smoothing, quality);
	}

	/**
		Compresses this BitmapData object using the selected compressor algorithm and
		returns a new ByteArray object. Optionally, writes the resulting data to the
		specified ByteArray. The `compressor` argument specifies the encoding algorithm,
		and can be PNGEncoderOptions, JPEGEncoderOptions, or JPEGXREncoderOptions.

		The following example compresses a BitmapData object using the JPEGEncoderOptions:

		```haxe
		// Compress a BitmapData object as a JPEG file.
		var bitmapData:BitmapData = new BitmapData(640,480,false,0x00FF00);
		var byteArray:ByteArray = new ByteArray();
		bitmapData.encode(new Rectangle(0,0,640,480), new openfl.display.JPEGEncoderOptions(), byteArray);
		```

		@param	rect	The area of the BitmapData object to compress.
		@param	compressor	The compressor type to use. Valid values are:
		flash.display.PNGEncoderOptions, flash.display.JPEGEncoderOptions, and
		flash.display.JPEGXREncoderOptions.
		@param	byteArray	The output ByteArray to hold the encoded image.
		@return	A ByteArray containing the encoded image.
	**/
	public encode(rect: Rectangle, compressor: Object, byteArray: ByteArray = null): ByteArray
	{
		if (!this.readable || rect == null) return byteArray = null;
		// return __backend.encode(rect, compressor, byteArray);
	}

	/**
		Fills a rectangular area of pixels with a specified ARGB color.

		@param rect  The rectangular area to fill.
		@param color The ARGB color value that fills the area. ARGB colors are
					 often specified in hexadecimal format; for example,
					 0xFF336699.
		@throws TypeError The rect is null.
	**/
	public fillRect(rect: Rectangle, color: number): void
	{
		if (rect == null) return;
		// return __backend.fillRect(rect, color);
	}

	/**
		Performs a flood fill operation on an image starting at an(_x_,
		_y_) coordinate and filling with a certain color. The
		`floodFill()` method is similar to the paint bucket tool in
		various paint programs. The color is an ARGB color that contains alpha
		information and color information.

		@param x     The _x_ coordinate of the image.
		@param y     The _y_ coordinate of the image.
		@param color The ARGB color to use as a fill.
	**/
	public floodFill(x: number, y: number, color: number): void
	{
		if (!this.readable) return;
		// return __backend.floodFill(x, y, color);
	}

	/**
		Creates a new BitmapData instance from Base64-encoded data synchronously. This means
		that the BitmapData will be returned immediately (if supported).

		HTML5 and Flash do not support creating BitmapData synchronously, so these targets
		always return `null`. Other targets will return `null` if decoding was unsuccessful.

		@param	base64	Base64-encoded data
		@param	type	The MIME-type for the encoded data ("image/jpeg", etc)
		@returns	A new BitmapData if successful, or `null` if unsuccessful
	**/
	public static fromBase64(base64: string, type: string): BitmapData
	{
		if (base64 == null) return null;
		// return BitmapDataBackend.fromBase64(base64, type);
		return null;
	}

	/**
		Creates a new BitmapData from bytes (a haxe.io.Bytes or openfl.utils.ByteArray)
		synchronously. This means that the BitmapData will be returned immediately (if
		supported).

		HTML5 and Flash do not support creating BitmapData synchronously, so these targets
		always return `null`. Other targets will return `null` if decoding was unsuccessful.

		The optional `rawAlpha` parameter makes it easier to process images that have alpha
		data stored separately.

		@param	bytes	A haxe.io.Bytes or openfl.utils.ByteArray instance
		@param	rawAlpha	An optional byte array with alpha data
		@returns	A new BitmapData if successful, or `null` if unsuccessful
	**/
	public static fromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): BitmapData
	{
		if (bytes == null) return null;
		// return BitmapDataBackend.fromBytes(bytes, rawAlpha);
		return null;
	}

	/**
		Creates a new BitmapData from an HTML5 canvas element immediately.

		All targets except from HTML5 targets will return `null`.

		@param	canvas	An HTML5 canvas element
		@param	transparent	Whether the new BitmapData object should be considered
		transparent
		@returns	A new BitmapData if successful, or `null` if unsuccessful
	**/
	public static fromCanvas(canvas: HTMLCanvasElement, transparent: boolean = true): BitmapData
	{
		if (canvas == null) return null;
		// return BitmapDataBackend.fromCanvas(canvas, transparent);
		return null;
	}

	/**
		Creates a new BitmapData from a file path synchronously. This means that the
		BitmapData will be returned immediately (if supported).

		HTML5 and Flash do not support creating BitmapData synchronously, so these targets
		always return `null`.

		In order to load files from a remote web address, use the `loadFromFile` method,
		which supports asynchronous loading.

		@param	path	A local file path containing an image
		@returns	A new BitmapData if successful, or `null` if unsuccessful
	**/
	public static fromFile(path: string): BitmapData
	{
		if (path == null) return null;
		// return BitmapDataBackend.fromFile(path);
		return null;
	}

	/**
		Creates a new BitmapData using an existing Lime Image instance.

		@param	image	A Lime Image object
		@param	transparent	Whether the new BitmapData object should be considered
		transparent
		@returns	A new BitmapData if the Image (and associated ImageBuffer) are not
		`null`, otherwise `null` will be returned
	**/
	// public static fromImage(image: Image, transparent: boolean = true): BitmapData
	// {
	// 	if (image == null || image.buffer == null) return null;
	// 	// return BitmapDataBackend.fromImage(image, transparent);
	// 	return null;
	// }

	/**
		**BETA**

		Creates a new BitmapData instance from a Stage3D rectangle texture.

		This method is not supported by the Flash target.

		@param	texture	A Texture or RectangleTexture instance
		@returns	A new BitmapData if successful, or `null` if unsuccessful
	**/
	public static fromTexture(texture: TextureBase): BitmapData
	{
		if (texture == null) return null;
		// return BitmapDataBackend.fromTexture(texture);
		return null;
	}

	/**
		Determines the destination rectangle that the `applyFilter()`
		method call affects, given a BitmapData object, a source rectangle, and a
		filter object.

		For example, a blur filter normally affects an area larger than the
		size of the original image. A 100 x 200 pixel image that is being filtered
		by a default BlurFilter instance, where `blurX = blurY = 4`
		generates a destination rectangle of `(-2,-2,104,204)`. The
		`generateFilterRect()` method lets you find out the size of
		this destination rectangle in advance so that you can size the destination
		image appropriately before you perform a filter operation.

		Some filters clip their destination rectangle based on the source image
		size. For example, an inner `DropShadow` does not generate a
		larger result than its source image. In this API, the BitmapData object is
		used as the source bounds and not the source `rect`
		parameter.

		@param sourceRect A rectangle defining the area of the source image to use
						  as input.
		@param filter     A filter object that you use to calculate the
						  destination rectangle.
		@return A destination rectangle computed by using an image, the
				`sourceRect` parameter, and a filter.
		@throws TypeError The sourceRect or filter are null.
	**/
	public generateFilterRect(sourceRect: Rectangle, filter: BitmapFilter): Rectangle
	{
		// return __backend.generateFilterRect(sourceRect, filter);
		return null;
	}

	/**
		**BETA**

		Get the IndexBuffer3D object associated with this BitmapData object

		@hidden
		@param	context	A Stage3D context
		@returns	An IndexBuffer3D object for use with rendering
	**/
	// public getIndexBuffer(context: Context3D, scale9Grid: Rectangle = null): IndexBuffer3D
	// {
	// return Context3DBitmapData.getIndexBuffer(this, context, scale9Grid);
	// return null;
	// }

	/**
		**BETA**

		Get the VertexBuffer3D object associated with this BitmapData object

		@hidden
		@param	context	A Stage3D context
		@returns	A VertexBuffer3D object for use with rendering
	**/
	// public getVertexBuffer(context: Context3D, scale9Grid: Rectangle = null, targetObject: DisplayObject = null): VertexBuffer3D
	// {
	// return Context3DBitmapData.getVertexBuffer(this, context, scale9Grid, targetObject);
	// }

	/**
		Determines a rectangular region that either fully encloses all pixels of a
		specified color within the bitmap image(if the `findColor`
		parameter is set to `true`) or fully encloses all pixels that
		do not include the specified color(if the `findColor`
		parameter is set to `false`).

		For example, if you have a source image and you want to determine the
		rectangle of the image that contains a nonzero alpha channel, pass
		`{mask: 0xFF000000, color: 0x00000000}` as parameters. If the
		`findColor` parameter is set to `true`, the entire
		image is searched for the bounds of pixels for which `(value & mask)
		== color`(where `value` is the color value of the
		pixel). If the `findColor` parameter is set to
		`false`, the entire image is searched for the bounds of pixels
		for which `(value & mask) != color`(where `value`
		is the color value of the pixel). To determine white space around an
		image, pass `{mask: 0xFFFFFFFF, color: 0xFFFFFFFF}` to find the
		bounds of nonwhite pixels.

		@param mask      A hexadecimal value, specifying the bits of the ARGB
						 color to consider. The color value is combined with this
						 hexadecimal value, by using the `&`(bitwise
						 AND) operator.
		@param color     A hexadecimal value, specifying the ARGB color to match
						(if `findColor` is set to `true`)
						 or _not_ to match(if `findColor` is set
						 to `false`).
		@param findColor If the value is set to `true`, returns the
						 bounds of a color value in an image. If the value is set
						 to `false`, returns the bounds of where this
						 color doesn't exist in an image.
		@return The region of the image that is the specified color.
	**/
	public getColorBoundsRect(mask: number, color: number, findColor: boolean = true): Rectangle
	{
		if (!this.readable) return new Rectangle(0, 0, this.__width, this.__height);
		// return __backend.getColorBoundsRect(mask, color, findColor);
		return null;
	}

	/**
		Returns an integer that represents an RGB pixel value from a BitmapData
		object at a specific point(_x_, _y_). The
		`getPixel()` method returns an unmultiplied pixel value. No
		alpha information is returned.

		All pixels in a BitmapData object are stored as premultiplied color
		values. A premultiplied image pixel has the red, green, and blue color
		channel values already multiplied by the alpha data. For example, if the
		alpha value is 0, the values for the RGB channels are also 0, independent
		of their unmultiplied values. This loss of data can cause some problems
		when you perform operations. All BitmapData methods take and return
		unmultiplied values. The internal pixel representation is converted from
		premultiplied to unmultiplied before it is returned as a value. During a
		set operation, the pixel value is premultiplied before the raw image pixel
		is set.

		@param x The _x_ position of the pixel.
		@param y The _y_ position of the pixel.
		@return A number that represents an RGB pixel value. If the(_x_,
				_y_) coordinates are outside the bounds of the image, the
				method returns 0.
	**/
	public getPixel(x: number, y: number): number
	{
		if (!this.readable) return 0;
		// return __backend.getPixel(x, y);
		return 0;
	}

	/**
		Returns an ARGB color value that contains alpha channel data and RGB data.
		This method is similar to the `getPixel()` method, which
		returns an RGB color without alpha channel data.

		All pixels in a BitmapData object are stored as premultiplied color
		values. A premultiplied image pixel has the red, green, and blue color
		channel values already multiplied by the alpha data. For example, if the
		alpha value is 0, the values for the RGB channels are also 0, independent
		of their unmultiplied values. This loss of data can cause some problems
		when you perform operations. All BitmapData methods take and return
		unmultiplied values. The internal pixel representation is converted from
		premultiplied to unmultiplied before it is returned as a value. During a
		set operation, the pixel value is premultiplied before the raw image pixel
		is set.

		@param x The _x_ position of the pixel.
		@param y The _y_ position of the pixel.
		@return A number representing an ARGB pixel value. If the(_x_,
				_y_) coordinates are outside the bounds of the image, 0 is
				returned.
	**/
	public getPixel32(x: number, y: number): number
	{
		if (!this.readable) return 0;
		// return __backend.getPixel32(x, y);
		return 0;
	}

	/**
		Generates a byte array from a rectangular region of pixel data. Writes an
		unsigned integer(a 32-bit unmultiplied pixel value) for each pixel into
		the byte array.

		@param rect A rectangular area in the current BitmapData object.
		@return A ByteArray representing the pixels in the given Rectangle.
		@throws TypeError The rect is null.
	**/
	public getPixels(rect: Rectangle): ByteArray
	{
		if (!this.readable) return null;
		if (rect == null) rect = this.rect;
		// return __backend.getPixels(rect);
		return null;
	}

	/**
		**BETA**

		Get a hardware texture representing this BitmapData instance

		@hidden
		@param	context	A Context3D instance
		@returns	A Texture or RectangleTexture instance
	**/
	// public getTexture(context: Context3D): TextureBase
	// {
	// 	if (!this.__isValid) return null;
	// return __backend.getTexture(context);
	// }

	/**
		Generates a vector array from a rectangular region of pixel data. Returns
		a Vector object of unsigned integers(a 32-bit unmultiplied pixel value)
		for the specified rectangle.
		@param rect A rectangular area in the current BitmapData object.
		@return A Vector representing the given Rectangle.
		@throws TypeError The rect is null.
	**/
	public getVector(rect: Rectangle): Vector<number>
	{
		// return __backend.getVector(rect);
		return null;
	}

	/**
		Computes a 256-value binary number histogram of a BitmapData object. This method
		returns a Vector object containing four Vector<number> instances (four Vector
		objects that contain Float objects). The four Vector instances represent the
		red, green, blue and alpha components in order. Each Vector instance contains
		256 values that represent the population count of an individual component value,
		from 0 to 255.
		@param	hRect	The area of the BitmapData object to use.
	**/
	public histogram(hRect: Rectangle = null): Array<Array<number>>
	{
		// return __backend.histogram(hRect);
		return null;
	}

	/**
		Performs pixel-level hit detection between one bitmap image and a point,
		rectangle, or other bitmap image. A hit is defined as an overlap of a point or
		rectangle over an opaque pixel, or two overlapping opaque pixels. No stretching,
		rotation, or other transformation of either object is considered when the hit test
		is performed.

		If an image is an opaque image, it is considered a fully opaque rectangle for this
		method. Both images must be transparent images to perform pixel-level hit testing
		that considers transparency. When you are testing two transparent images, the alpha
		threshold parameters control what alpha channel values, from 0 to 255, are
		considered opaque.

		@param	firstPoint	A position of the upper-left corner of the BitmapData image
		in an arbitrary coordinate space. The same coordinate space is used in defining
		the secondBitmapPoint parameter.
		@param	firstAlphaThreshold	The smallest alpha channel value that is considered
		opaque for this hit test.
		@param	secondObject	A Rectangle, Point, Bitmap, or BitmapData object.
		@param	secondBitmapDataPoint	A point that defines a pixel location in the
		second BitmapData object. Use this parameter only when the value of `secondObject`
		is a BitmapData object.
		@param	secondAlphaThreshold	The smallest alpha channel value that is
		considered opaque in the second BitmapData object. Use this parameter only when
		the value of `secondObject` is a BitmapData object and both BitmapData objects
		are transparent.
		@return	A value of `true` if a hit occurs; otherwise, `false`.
		@throws	ArgumentError	The `secondObject` parameter is not a Point, Rectangle,
		Bitmap, or BitmapData object.
		@throws	TypeError	The `firstPoint` is `null`.
	**/
	public hitTest(firstPoint: Point, firstAlphaThreshold: number, secondObject: Object, secondBitmapDataPoint: Point = null,
		secondAlphaThreshold: number = 1): boolean
	{
		if (!this.readable) return false;
		// return __backend.hitTest(firstPoint, firstAlphaThreshold, secondObject, secondBitmapDataPoint, secondAlphaThreshold);
		return false;
	}

	/**
		Creates a new BitmapData from Base64-encoded data asynchronously. The data
		and (if successful) decoding the data into an image occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	base64	Base64-encoded data
		@param	type	The MIME-type for the encoded data ("image/jpeg", etc)
		@returns	A Future BitmapData
	**/
	public static loadFromBase64(base64: string, type: string): Future<BitmapData>
	{
		// return BitmapDataBackend.loadFromBase64(base64, type);
		return null;
	}

	/**
		Creates a new BitmapData from haxe.io.Bytes or openfl.utils.ByteArray data
		asynchronously. The data and image decoding will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		The optional `rawAlpha` parameter makes it easier to process images that have alpha
		data stored separately.

		@param	bytes	A haxe.io.Bytes or openfl.utils.ByteArray instance
		@param	rawAlpha	An optional byte array with alpha data
		@returns	A Future BitmapData
	**/
	public static loadFromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): Future<BitmapData>
	{
		// return BitmapDataBackend.loadFromBytes(bytes, rawAlpha);
		return null;
	}

	/**
		Creates a new BitmapData from a file path or web address asynchronously. The file
		load and image decoding will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	path	A local file path or web address containing an image
		@returns	A Future BitmapData
	**/
	public static loadFromFile(path: string): Future<BitmapData>
	{
		// return BitmapDataBackend.loadFromFile(path);
		return null;
	}

	/**
		Locks an image so that any objects that reference the BitmapData object,
		such as Bitmap objects, are not updated when this BitmapData object
		changes. To improve performance, use this method along with the
		`unlock()` method before and after numerous calls to the
		`setPixel()` or `setPixel32()` method.

	**/
	public lock(): void { }

	/**
		Performs per-channel blending from a source image to a destination image. For
		each channel and each pixel, a new value is computed based on the channel
		values of the source and destination pixels. For example, in the red channel,
		the new value is computed as follows (where `redSrc` is the red channel value
		for a pixel in the source image and `redDest` is the red channel value at the
		corresponding pixel of the destination image):

		```haxe
		redDest = [(redSrc * redMultiplier) + (redDest * (256 - redMultiplier))] / 256;
		```

		The `redMultiplier`, `greenMultiplier`, `blueMultiplier`, and `alphaMultiplier`
		values are the multipliers used for each color channel. Use a hexadecimal
		value ranging from 0 to 0x100 (256) where 0 specifies the full value from the
		destination is used in the result, 0x100 specifies the full value from the
		source is used, and numbers in between specify a blend is used (such as 0x80
		for 50%).

		@param	sourceBitmapData	The input bitmap image to use. The source image can
		be a different BitmapData object, or it can refer to the current BitmapData
		object.
		@param	sourceRect	A rectangle that defines the area of the source image to use
		as input.
		@param	destPoint	The point within the destination image (the current
		BitmapData instance) that corresponds to the upper-left corner of the source
		rectangle.
		@param	redMultiplier	A hexadecimal uint value by which to multiply the red
		channel value.
		@param	greenMultiplier	A hexadecimal uint value by which to multiply the green
		channel value.
		@param	blueMultiplier	A hexadecimal uint value by which to multiply the blue
		channel value.
		@param	alphaMultiplier	A hexadecimal uint value by which to multiply the alpha
		transparency value.
		@throws	TypeError	The `sourceBitmapData`, `sourceRect` or `destPoint` are `null`.
	**/
	public merge(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, redMultiplier: number, greenMultiplier: number, blueMultiplier: number,
		alphaMultiplier: number): void
	{
		if (!this.readable || sourceBitmapData == null || !sourceBitmapData.readable || sourceRect == null || destPoint == null) return;
		// __backend.merge(sourceBitmapData, sourceRect, destPoint, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);
	}

	/**
		Fills an image with pixels representing random noise.

		@param randomSeed     The random seed number to use. If you keep all other
							  parameters the same, you can generate different
							  pseudo-random results by varying the random seed
							  value. The noise is a mapping function, not
							  a true random-number generation function, so it
							  creates the same results each time from the same
							  random seed.
		@param low            The lowest value to generate for each channel(0 to
							  255).
		@param high           The highest value to generate for each channel(0 to
							  255).
		@param channelOptions A number that can be a combination of any of the
							  four color channel values
							 (`BitmapDataChannel.RED`,
							  `BitmapDataChannel.BLUE`,
							  `BitmapDataChannel.GREEN`, and
							  `BitmapDataChannel.ALPHA`). You can use
							  the logical OR operator(`|`) to combine
							  channel values.
		@param grayScale      A Boolean value. If the value is `true`,
							  a grayscale image is created by setting all of the
							  color channels to the same value. The alpha channel
							  selection is not affected by setting this parameter
							  to `true`.
	**/
	public noise(randomSeed: number, low: number = 0, high: number = 255, channelOptions: number = 7, grayScale: boolean = false): void
	{
		if (!this.readable) return;
		// return __backend.noise(randomSeed, low, high, channelOptions, grayScale);
	}

	/**
		Remaps the color channel values in an image that has up to four arrays of
		color palette data, one for each channel.

		Flash runtimes use the following steps to generate the resulting image:

		1. After the red, green, blue, and alpha values are computed, they are added
		together using standard 32-bit-integer arithmetic.
		2. The red, green, blue, and alpha channel values of each pixel are extracted
		into separate 0 to 255 values. These values are used to look up new color
		values in the appropriate array: `redArray`, `greenArray`, `blueArray`, and
		`alphaArray`. Each of these four arrays should contain 256 values.
		3. After all four of the new channel values are retrieved, they are combined
		into a standard ARGB value that is applied to the pixel.

		Cross-channel effects can be supported with this method. Each input array can
		contain full 32-bit values, and no shifting occurs when the values are added
		together. This routine does not support per-channel clamping.

		If no array is specified for a channel, the color channel is copied from the
		source image to the destination image.

		You can use this method for a variety of effects such as general palette mapping
		(taking one channel and converting it to a false color image). You can also use
		this method for a variety of advanced color manipulation algorithms, such as
		gamma, curves, levels, and quantizing.

		@param	sourceBitmapData	The input bitmap image to use. The source image can
		be a different BitmapData object, or it can refer to the current BitmapData
		instance.
		@param	sourceRect	A rectangle that defines the area of the source image to use
		as input.
		@param	destPoint	The point within the destination image (the current BitmapData
		object) that corresponds to the upper-left corner of the source rectangle.
		@param	redArray	If `redArray` is not `null`, `red = redArray[source red value] else red = source rect value`.
		@param	greenArray	If `greenArray` is not `null`, `green = greenArray[source green value] else green = source green value`.
		@param	blueArray	If `blueArray` is not `null, `blue = blueArray[source blue value] else blue = source blue value`.
		@param	alphaArray	If `alphaArray` is not `null, `alpha = alphaArray[source alpha value] else alpha = source alpha value`.
		@throws	TypeError	The `sourceBitmapData`, `sourceRect` or `destPoint` are `null`.
	**/
	public paletteMap(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, redArray: Array<Number> = null, greenArray: Array<Number> = null,
		blueArray: Array<Number> = null, alphaArray: Array<Number> = null): void
	{
		// return __backend.paletteMap(sourceBitmapData, sourceRect, destPoint, redArray, greenArray, blueArray, alphaArray);
	}

	/**
		Generates a Perlin noise image.

		The Perlin noise generation algorithm interpolates and combines
		individual random noise functions(called octaves) into a single function
		that generates more natural-seeming random noise. Like musical octaves,
		each octave is twice the frequency of the one before it. Perlin
		noise has been described as a "fractal sum of noise" because it combines
		multiple sets of noise data with different levels of detail.

		You can use Perlin noise functions to simulate natural phenomena and
		landscapes, such as wood grain, clouds, and mountain ranges. In most
		cases, the output of a Perlin noise is not displayed directly but
		is used to enhance other images and give them pseudo-random
		variations.

		Simple digital random noise functions often produce images with harsh,
		contrasting points. This kind of harsh contrast is not often found in
		nature. The Perlin noise algorithm blends multiple noise functions that
		operate at different levels of detail. This algorithm results in smaller
		variations among neighboring pixel values.

		@param baseX          Frequency to use in the _x_ direction. For
							  example, to generate a noise that is sized for a 64
							  x 128 image, pass 64 for the `baseX`
							  value.
		@param baseY          Frequency to use in the _y_ direction. For
							  example, to generate a noise that is sized for a 64
							  x 128 image, pass 128 for the `baseY`
							  value.
		@param numOctaves     Number of octaves or individual noise functions to
							  combine to create this noise. Larger numbers of
							  octaves create images with greater detail. Larger
							  numbers of octaves also require more processing
							  time.
		@param randomSeed     The random seed number to use. If you keep all other
							  parameters the same, you can generate different
							  pseudo-random results by varying the random seed
							  value. The Perlin noise is a mapping
							  function, not a true random-number generation
							  function, so it creates the same results each time
							  from the same random seed.
		@param stitch         A Boolean value. If the value is `true`,
							  the method attempts to smooth the transition edges
							  of the image to create seamless textures for tiling
							  as a bitmap fill.
		@param fractalNoise   A Boolean value. If the value is `true`,
							  the method generates fractal noise; otherwise, it
							  generates turbulence. An image with turbulence has
							  visible discontinuities in the gradient that can
							  make it better approximate sharper visual effects
							  like flames and ocean waves.
		@param channelOptions A number that can be a combination of any of the
							  four color channel values
							 (`BitmapDataChannel.RED`,
							  `BitmapDataChannel.BLUE`,
							  `BitmapDataChannel.GREEN`, and
							  `BitmapDataChannel.ALPHA`). You can use
							  the logical OR operator(`|`) to combine
							  channel values.
		@param grayScale      A Boolean value. If the value is `true`,
							  a grayscale image is created by setting each of the
							  red, green, and blue color channels to identical
							  values. The alpha channel value is not affected if
							  this value is set to `true`.
	**/
	public perlinNoise(baseX: number, baseY: number, numOctaves: number, randomSeed: number, stitch: boolean, fractalNoise: boolean, channelOptions: number = 7,
		grayScale: boolean = false, offsets: Array<Point> = null): void
	{
		if (!this.readable) return;
		// return __backend.perlinNoise(baseX, baseY, numOctaves, randomSeed, stitch, fractalNoise, channelOptions, grayScale, offsets);
	}

	// /** @hidden */ @:dox(hide) public pixelDissolve (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, randomSeed:Int = 0, numPixels:Int = 0, fillColor:UInt = 0):Int;

	/**
		Scrolls an image by a certain(_x_, _y_) pixel amount. Edge
		regions outside the scrolling area are left unchanged.

		@param x The amount by which to scroll horizontally.
		@param y The amount by which to scroll vertically.
	**/
	public scroll(x: number, y: number): void
	{
		if (!this.readable) return;
		// return __backend.scroll(x, y);
	}

	/**
		Sets a single pixel of a BitmapData object. The current alpha channel
		value of the image pixel is preserved during this operation. The value of
		the RGB color parameter is treated as an unmultiplied color value.

		**Note:** To increase performance, when you use the
		`setPixel()` or `setPixel32()` method repeatedly,
		call the `lock()` method before you call the
		`setPixel()` or `setPixel32()` method, and then call
		the `unlock()` method when you have made all pixel changes.
		This process prevents objects that reference this BitmapData instance from
		updating until you finish making the pixel changes.

		@param x     The _x_ position of the pixel whose value changes.
		@param y     The _y_ position of the pixel whose value changes.
		@param color The resulting RGB color for the pixel.
	**/
	public setPixel(x: number, y: number, color: number): void
	{
		if (!this.readable) return;
		// return __backend.setPixel(x, y, color);
	}

	/**
		Sets the color and alpha transparency values of a single pixel of a
		BitmapData object. This method is similar to the `setPixel()`
		method; the main difference is that the `setPixel32()` method
		takes an ARGB color value that contains alpha channel information.

		All pixels in a BitmapData object are stored as premultiplied color
		values. A premultiplied image pixel has the red, green, and blue color
		channel values already multiplied by the alpha data. For example, if the
		alpha value is 0, the values for the RGB channels are also 0, independent
		of their unmultiplied values. This loss of data can cause some problems
		when you perform operations. All BitmapData methods take and return
		unmultiplied values. The internal pixel representation is converted from
		premultiplied to unmultiplied before it is returned as a value. During a
		set operation, the pixel value is premultiplied before the raw image pixel
		is set.

		**Note:** To increase performance, when you use the
		`setPixel()` or `setPixel32()` method repeatedly,
		call the `lock()` method before you call the
		`setPixel()` or `setPixel32()` method, and then call
		the `unlock()` method when you have made all pixel changes.
		This process prevents objects that reference this BitmapData instance from
		updating until you finish making the pixel changes.

		@param x     The _x_ position of the pixel whose value changes.
		@param y     The _y_ position of the pixel whose value changes.
		@param color The resulting ARGB color for the pixel. If the bitmap is
					 opaque(not transparent), the alpha transparency portion of
					 this color value is ignored.
	**/
	public setPixel32(x: number, y: number, color: number): void
	{
		if (!this.readable) return;
		// return __backend.setPixel32(x, y, color);
	}

	/**
		Converts a byte array into a rectangular region of pixel data. For each
		pixel, the `ByteArray.readUnsignedInt()` method is called and
		the return value is written into the pixel. If the byte array ends before
		the full rectangle is written, the returns. The data in the byte
		array is expected to be 32-bit ARGB pixel values. No seeking is performed
		on the byte array before or after the pixels are read.

		@param rect           Specifies the rectangular region of the BitmapData
							  object.
		@param inputByteArray A ByteArray object that consists of 32-bit
							  unmultiplied pixel values to be used in the
							  rectangular region.
		@throws EOFError  The `inputByteArray` object does not include
						  enough data to fill the area of the `rect`
						  rectangle. The method fills as many pixels as possible
						  before throwing the exception.
		@throws TypeError The rect or inputByteArray are null.
	**/
	public setPixels(rect: Rectangle, byteArray: ByteArray): void
	{
		if (!this.readable || rect == null || byteArray == null) return;
		var length = (rect.width * rect.height * 4);
		if (byteArray.bytesAvailable < length) throw new Error("End of file was encountered.", 2030);

		// return __backend.setPixels(rect, byteArray);
	}

	/**
		Converts a Vector into a rectangular region of pixel data. For each pixel,
		a Vector element is read and written into the BitmapData pixel. The data
		in the Vector is expected to be 32-bit ARGB pixel values.

		@param rect Specifies the rectangular region of the BitmapData object.
		@throws RangeError The vector array is not large enough to read all the
						   pixel data.
	**/
	public setVector(rect: Rectangle, inputVector: Vector<number>): void
	{
		if (inputVector == null) return;
		// __backend.setVector(rect, inputVector);
	}

	/**
		Tests pixel values in an image against a specified threshold and sets
		pixels that pass the test to new color values. Using the
		`threshold()` method, you can isolate and replace color ranges
		in an image and perform other logical operations on image pixels.

		The `threshold()` method's test logic is as follows:

		 1. If `((pixelValue & mask) operation(threshold & mask))`,
		then set the pixel to `color`;
		 2. Otherwise, if `copySource == true`, then set the pixel to
		corresponding pixel value from `sourceBitmap`.

		The `operation` parameter specifies the comparison operator
		to use for the threshold test. For example, by using "==" as the
		`operation` parameter, you can isolate a specific color value
		in an image. Or by using `{operation: "<", mask: 0xFF000000,
		threshold: 0x7F000000, color: 0x00000000}`, you can set all
		destination pixels to be fully transparent when the source image pixel's
		alpha is less than 0x7F. You can use this technique for animated
		transitions and other effects.

		@param sourceBitmapData The input bitmap image to use. The source image
								can be a different BitmapData object or it can
								refer to the current BitmapData instance.
		@param sourceRect       A rectangle that defines the area of the source
								image to use as input.
		@param destPoint        The point within the destination image(the
								current BitmapData instance) that corresponds to
								the upper-left corner of the source rectangle.
		@param operation        One of the following comparison operators, passed
								as a String: "<", "<=", ">", ">=", "==", "!="
		@param threshold        The value that each pixel is tested against to see
								if it meets or exceeds the threshhold.
		@param color            The color value that a pixel is set to if the
								threshold test succeeds. The default value is
								0x00000000.
		@param mask             The mask to use to isolate a color component.
		@param copySource       If the value is `true`, pixel values
								from the source image are copied to the
								destination when the threshold test fails. If the
								value is `false`, the source image is
								not copied when the threshold test fails.
		@return The number of pixels that were changed.
		@throws ArgumentError The operation string is not a valid operation
		@throws TypeError     The sourceBitmapData, sourceRect destPoint or
							  operation are null.
	**/
	public threshold(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, operation: string, threshold: number, color: number = 0x00000000,
		mask: number = 0xFFFFFFFF, copySource: boolean = false): number
	{
		if (sourceBitmapData == null
			|| sourceRect == null
			|| destPoint == null
			|| sourceRect.x > sourceBitmapData.width
			|| sourceRect.y > sourceBitmapData.height
			|| destPoint.x > this.__width
			|| destPoint.y > this.__height)
		{
			return 0;
		}

		// return __backend.threshold(sourceBitmapData, sourceRect, destPoint, operation, threshold, color, mask, copySource);
		return 0;
	}

	/**
		Unlocks an image so that any objects that reference the BitmapData object,
		such as Bitmap objects, are updated when this BitmapData object changes.
		To improve performance, use this method along with the `lock()`
		method before and after numerous calls to the `setPixel()` or
		`setPixel32()` method.

		@param changeRect The area of the BitmapData object that has changed. If
						  you do not specify a value for this parameter, the
						  entire area of the BitmapData object is considered
						  changed.
	**/
	public unlock(changeRect: Rectangle = null): void { }

	protected __getBounds(rect: Rectangle, matrix: Matrix): void
	{
		var bounds = (<internal.Rectangle><any>Rectangle).__pool.get();
		(<internal.Rectangle><any>this.rect).__transform(bounds, matrix);
		(<internal.Rectangle><any>rect).__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		(<internal.Rectangle><any>Rectangle).__pool.release(bounds);
	}

	protected __getCanvas(clearData: boolean = false): HTMLCanvasElement
	{
		// return __backend.getCanvas(clearData);
		return null;
	}

	protected __getCanvasContext(clearData: boolean = false): CanvasRenderingContext2D
	{
		// return __backend.getCanvasContext(clearData);
		return null;
	}

	protected __getElement(clearData: boolean = false): CanvasImageSource
	{
		// return __backend.getElement(clearData);
		return null;
	}

	protected __getJSImage(): HTMLImageElement
	{
		// return __backend.getJSImage();
		return null;
	}

	protected __getVersion(): number
	{
		// return __backend.getVersion();
		return 0;
	}

	protected __setDirty(): void
	{
		// __backend.setDirty();
	}

	protected __update(transformOnly: boolean, updateChildren: boolean): void { }

	// Get & Set Methods

	/**
		The height of the bitmap image in pixels.
	**/
	public get height(): number
	{
		return this.__height;
	}

	/**
		Defines whether the bitmap image is readable. Hardware-only bitmap images
		do not support `getPixels`, `setPixels` and other
		BitmapData methods, though they can still be used inside a Bitmap object
		or other display objects that do not need to modify the pixels.

		As an exception to the rule, `bitmapData.draw` is supported for
		non-readable bitmap images.

		Since non-readable bitmap images do not have a software image buffer, they
		will need to be recreated if the current hardware rendering context is lost.
	**/
	public get readable(): boolean
	{
		return this.__readable;
	}

	// #end

	/**
		The rectangle that defines the size and location of the bitmap image. The
		top and left of the rectangle are 0; the width and height are equal to the
		width and height in pixels of the BitmapData object.
	**/
	public get rect(): Rectangle
	{
		return this.__rect;
	}

	/**
		Defines whether the bitmap image supports per-pixel transparency. You can
		set this value only when you construct a BitmapData object by passing in
		`true` for the `transparent` parameter of the
		constructor. Then, after you create a BitmapData object, you can check
		whether it supports per-pixel transparency by determining if the value of
		the `transparent` property is `true`.
	**/
	public get transparent(): boolean
	{
		return this.__transparent;
	}

	/**
		The width of the bitmap image in pixels.
	**/
	public get width(): number
	{
		return this.__width;
	}
}
