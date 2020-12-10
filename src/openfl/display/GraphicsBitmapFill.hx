package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;
import openfl.display._internal.GraphicsFillType;
import openfl.geom.Matrix;

/**
	Defines a bitmap fill. The bitmap can be smoothed, repeated or tiled to
	fill the area; or manipulated using a transformation matrix.
	Use a GraphicsBitmapFill object with the `Graphics.drawGraphicsData()`
	method. Drawing a GraphicsBitmapFill object is the equivalent of calling
	the `Graphics.beginBitmapFill()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsBitmapFill implements IGraphicsData implements IGraphicsFill
{
	/**
		A transparent or opaque bitmap image.
	**/
	public var bitmapData:BitmapData;

	/**
		A matrix object (of the openfl.geom.Matrix class) that defines
		transformations on the bitmap. For example, the following matrix
		rotates a bitmap by 45 degrees (pi/4 radians):

		```haxe
		var matrix = new openfl.geom.Matrix();
		matrix.rotate(Math.PI / 4);
		```
	**/
	public var matrix:Matrix;

	/**
		Specifies whether to repeat the bitmap image in a tiled pattern.
		If `true`, the bitmap image repeats in a tiled pattern. If `false`,
		the bitmap image does not repeat, and the outermost pixels along the
		edges of the bitmap are used for any fill area that extends beyond the
		bounds of the bitmap.

		For example, consider the following bitmap (a 20 x 20-pixel
		checkerboard pattern):

		![20 by 20 pixel checkerboard](/images/movieClip_beginBitmapFill_repeat_1.jpg)

		When `repeat` is set to `true` (as in the following example), the
		bitmap fill repeats the bitmap:

		![60 by 60 pixel checkerboard](/images/movieClip_beginBitmapFill_repeat_2.jpg)

		When `repeat` is set to `false`, the bitmap fill uses the edge pixels
		for the fill area outside the bitmap:

		![60 by 60 pixel image with no repeating](/images/movieClip_beginBitmapFill_repeat_3.jpg)
	**/
	public var repeat:Bool;

	/**
		Specifies whether to apply a smoothing algorithm to the bitmap image.
		If `false`, upscaled bitmap images are rendered by using a
		nearest-neighbor algorithm and look pixelated. If `true`, upscaled
		bitmap images are rendered by using a bilinear algorithm. Rendering by
		using the nearest neighbor algorithm is usually faster.
	**/
	public var smooth:Bool;

	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;

	/**
		Creates a new GraphicsBitmapFill object.

		@param bitmapData A transparent or opaque bitmap image that contains
						  the bits to display.
		@param matrix     A matrix object (of the openfl.geom.Matrix class),
						  which you use to define transformations on the
						  bitmap.
		@param repeat     If `true`, the bitmap image repeats in a tiled
						  pattern. If `false`, the bitmap image does not
						  repeat, and the edges of the bitmap are used for any
						  fill area that extends beyond the bitmap.
		@param smooth     If `false`, upscaled bitmap images are rendered
						  using a nearest-neighbor algorithm and appear
						  pixelated. If `true`, upscaled bitmap images are
						  rendered using a bilinear algorithm. Rendering that
						  uses the nearest-neighbor algorithm is usually
						  faster.
	**/
	public function new(bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false)
	{
		this.bitmapData = bitmapData;
		this.matrix = matrix;
		this.repeat = repeat;
		this.smooth = smooth;

		this.__graphicsDataType = BITMAP;
		this.__graphicsFillType = BITMAP_FILL;
	}
}
#else
typedef GraphicsBitmapFill = flash.display.GraphicsBitmapFill;
#end
