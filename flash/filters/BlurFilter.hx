package flash.filters;
#if (flash || display)


/**
 * The BlurFilter class lets you apply a blur visual effect to display
 * objects. A blur effect softens the details of an image. You can produce
 * blurs that range from a softly unfocused look to a Gaussian blur, a hazy
 * appearance like viewing an image through semi-opaque glass. When the
 * <code>quality</code> property of this filter is set to low, the result is a
 * softly unfocused look. When the <code>quality</code> property is set to
 * high, it approximates a Gaussian blur filter. You can apply the filter to
 * any display object(that is, objects that inherit from the DisplayObject
 * class), such as MovieClip, SimpleButton, TextField, and Video objects, as
 * well as to BitmapData objects.
 *
 * <p>To create a new filter, use the constructor <code>new
 * BlurFilter()</code>. The use of filters depends on the object to which you
 * apply the filter:</p>
 *
 * <ul>
 *   <li>To apply filters to movie clips, text fields, buttons, and video, use
 * the <code>filters</code> property(inherited from DisplayObject). Setting
 * the <code>filters</code> property of an object does not modify the object,
 * and you can remove the filter by clearing the <code>filters</code>
 * property. </li>
 *   <li>To apply filters to BitmapData objects, use the
 * <code>BitmapData.applyFilter()</code> method. Calling
 * <code>applyFilter()</code> on a BitmapData object takes the source
 * BitmapData object and the filter object and generates a filtered image as a
 * result.</li>
 * </ul>
 *
 * <p>If you apply a filter to a display object, the
 * <code>cacheAsBitmap</code> property of the display object is set to
 * <code>true</code>. If you remove all filters, the original value of
 * <code>cacheAsBitmap</code> is restored.</p>
 *
 * <p>This filter supports Stage scaling. However, it does not support general
 * scaling, rotation, and skewing. If the object itself is scaled
 * (<code>scaleX</code> and <code>scaleY</code> are not set to 100%), the
 * filter effect is not scaled. It is scaled only when the user zooms in on
 * the Stage.</p>
 *
 * <p>A filter is not applied if the resulting image exceeds the maximum
 * dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
 * width or height, and the total number of pixels cannot exceed 16,777,215
 * pixels.(So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
 * high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
 * limitation is 2,880 pixels in height and 2,880 pixels in width. If, for
 * example, you zoom in on a large movie clip with a filter applied, the
 * filter is turned off if the resulting image exceeds the maximum
 * dimensions.</p>
 */
@:final extern class BlurFilter extends BitmapFilter {

	/**
	 * The amount of horizontal blur. Valid values are from 0 to 255(floating
	 * point). The default value is 4. Values that are a power of 2(such as 2,
	 * 4, 8, 16 and 32) are optimized to render more quickly than other values.
	 */
	var blurX : Float;

	/**
	 * The amount of vertical blur. Valid values are from 0 to 255(floating
	 * point). The default value is 4. Values that are a power of 2(such as 2,
	 * 4, 8, 16 and 32) are optimized to render more quickly than other values.
	 */
	var blurY : Float;

	/**
	 * The number of times to perform the blur. The default value is
	 * <code>BitmapFilterQuality.LOW</code>, which is equivalent to applying the
	 * filter once. The value <code>BitmapFilterQuality.MEDIUM</code> applies the
	 * filter twice; the value <code>BitmapFilterQuality.HIGH</code> applies it
	 * three times and approximates a Gaussian blur. Filters with lower values
	 * are rendered more quickly.
	 *
	 * <p>For most applications, a <code>quality</code> value of low, medium, or
	 * high is sufficient. Although you can use additional numeric values up to
	 * 15 to increase the number of times the blur is applied, higher values are
	 * rendered more slowly. Instead of increasing the value of
	 * <code>quality</code>, you can often get a similar effect, and with faster
	 * rendering, by simply increasing the values of the <code>blurX</code> and
	 * <code>blurY</code> properties.</p>
	 *
	 * <p>You can use the following BitmapFilterQuality constants to specify
	 * values of the <code>quality</code> property:</p>
	 *
	 * <ul>
	 *   <li><code>BitmapFilterQuality.LOW</code></li>
	 *   <li><code>BitmapFilterQuality.MEDIUM</code></li>
	 *   <li><code>BitmapFilterQuality.HIGH</code></li>
	 * </ul>
	 */
	var quality : Int;

	/**
	 * Initializes the filter with the specified parameters. The default values
	 * create a soft, unfocused image.
	 * 
	 * @param blurX   The amount to blur horizontally. Valid values are from 0 to
	 *                255.0(floating-point value).
	 * @param blurY   The amount to blur vertically. Valid values are from 0 to
	 *                255.0(floating-point value).
	 * @param quality The number of times to apply the filter. You can specify
	 *                the quality using the BitmapFilterQuality constants:
	 *                <ul>
	 *
	 *                <li><code>flash.filters.BitmapFilterQuality.LOW</code></li>
	 *
	 *                <li><code>flash.filters.BitmapFilterQuality.MEDIUM</code></li>
	 *
	 *                <li><code>flash.filters.BitmapFilterQuality.HIGH</code></li>
	 *                </ul>
	 *
	 *                <p>High quality approximates a Gaussian blur. For most
	 *                applications, these three values are sufficient. Although
	 *                you can use additional numeric values up to 15 to achieve
	 *                different effects, be aware that higher values are rendered
	 *                more slowly.</p>
	 */
	function new(blurX : Float = 4, blurY : Float = 4, quality : Int = 1) : Void;
}


#end
