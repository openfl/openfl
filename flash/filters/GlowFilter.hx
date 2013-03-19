package flash.filters;
#if (flash || display)


/**
 * The GlowFilter class lets you apply a glow effect to display objects. You
 * have several options for the style of the glow, including inner or outer
 * glow and knockout mode. The glow filter is similar to the drop shadow
 * filter with the <code>distance</code> and <code>angle</code> properties of
 * the drop shadow filter set to 0. You can apply the filter to any display
 * object(that is, objects that inherit from the DisplayObject class), such
 * as MovieClip, SimpleButton, TextField, and Video objects, as well as to
 * BitmapData objects.
 *
 * <p>The use of filters depends on the object to which you apply the
 * filter:</p>
 *
 * <ul>
 *   <li>To apply filters to display objects, use the <code>filters</code>
 * property(inherited from DisplayObject). Setting the <code>filters</code>
 * property of an object does not modify the object, and you can remove the
 * filter by clearing the <code>filters</code> property. </li>
 *   <li>To apply filters to BitmapData objects, use the
 * <code>BitmapData.applyFilter()</code> method. Calling
 * <code>applyFilter()</code> on a BitmapData object takes the source
 * BitmapData object and the filter object and generates a filtered image as a
 * result.</li>
 * </ul>
 *
 * <p>If you apply a filter to a display object, the
 * <code>cacheAsBitmap</code> property of the display object is set to
 * <code>true</code>. If you clear all filters, the original value of
 * <code>cacheAsBitmap</code> is restored.</p>
 *
 * <p>This filter supports Stage scaling. However, it does not support general
 * scaling, rotation, and skewing. If the object itself is scaled(if
 * <code>scaleX</code> and <code>scaleY</code> are set to a value other than
 * 1.0), the filter is not scaled. It is scaled only when the user zooms in on
 * the Stage.</p>
 *
 * <p>A filter is not applied if the resulting image exceeds the maximum
 * dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
 * width or height, and the total number of pixels cannot exceed 16,777,215
 * pixels.(So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
 * high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
 * limitation is 2,880 pixels in height and 2,880 pixels in width. For
 * example, if you zoom in on a large movie clip with a filter applied, the
 * filter is turned off if the resulting image exceeds the maximum
 * dimensions.</p>
 */
@:final extern class GlowFilter extends BitmapFilter {

	/**
	 * The alpha transparency value for the color. Valid values are 0 to 1. For
	 * example, .25 sets a transparency value of 25%. The default value is 1.
	 */
	var alpha : Float;

	/**
	 * The amount of horizontal blur. Valid values are 0 to 255(floating point).
	 * The default value is 6. Values that are a power of 2(such as 2, 4, 8, 16,
	 * and 32) are optimized to render more quickly than other values.
	 */
	var blurX : Float;

	/**
	 * The amount of vertical blur. Valid values are 0 to 255(floating point).
	 * The default value is 6. Values that are a power of 2(such as 2, 4, 8, 16,
	 * and 32) are optimized to render more quickly than other values.
	 */
	var blurY : Float;

	/**
	 * The color of the glow. Valid values are in the hexadecimal format
	 * 0x<i>RRGGBB</i>. The default value is 0xFF0000.
	 */
	var color : Int;

	/**
	 * Specifies whether the glow is an inner glow. The value <code>true</code>
	 * indicates an inner glow. The default is <code>false</code>, an outer glow
	 * (a glow around the outer edges of the object).
	 */
	var inner : Bool;

	/**
	 * Specifies whether the object has a knockout effect. A value of
	 * <code>true</code> makes the object's fill transparent and reveals the
	 * background color of the document. The default value is <code>false</code>
	 * (no knockout effect).
	 */
	var knockout : Bool;

	/**
	 * The number of times to apply the filter. The default value is
	 * <code>BitmapFilterQuality.LOW</code>, which is equivalent to applying the
	 * filter once. The value <code>BitmapFilterQuality.MEDIUM</code> applies the
	 * filter twice; the value <code>BitmapFilterQuality.HIGH</code> applies it
	 * three times. Filters with lower values are rendered more quickly.
	 *
	 * <p>For most applications, a <code>quality</code> value of low, medium, or
	 * high is sufficient. Although you can use additional numeric values up to
	 * 15 to achieve different effects, higher values are rendered more slowly.
	 * Instead of increasing the value of <code>quality</code>, you can often get
	 * a similar effect, and with faster rendering, by simply increasing the
	 * values of the <code>blurX</code> and <code>blurY</code> properties.</p>
	 */
	var quality : Int;

	/**
	 * The strength of the imprint or spread. The higher the value, the more
	 * color is imprinted and the stronger the contrast between the glow and the
	 * background. Valid values are 0 to 255. The default is 2.
	 */
	var strength : Float;

	/**
	 * Initializes a new GlowFilter instance with the specified parameters.
	 * 
	 * @param color    The color of the glow, in the hexadecimal format
	 *                 0x<i>RRGGBB</i>. The default value is 0xFF0000.
	 * @param alpha    The alpha transparency value for the color. Valid values
	 *                 are 0 to 1. For example, .25 sets a transparency value of
	 *                 25%.
	 * @param blurX    The amount of horizontal blur. Valid values are 0 to 255
	 *                (floating point). Values that are a power of 2(such as 2,
	 *                 4, 8, 16 and 32) are optimized to render more quickly than
	 *                 other values.
	 * @param blurY    The amount of vertical blur. Valid values are 0 to 255
	 *                (floating point). Values that are a power of 2(such as 2,
	 *                 4, 8, 16 and 32) are optimized to render more quickly than
	 *                 other values.
	 * @param strength The strength of the imprint or spread. The higher the
	 *                 value, the more color is imprinted and the stronger the
	 *                 contrast between the glow and the background. Valid values
	 *                 are 0 to 255.
	 * @param quality  The number of times to apply the filter. Use the
	 *                 BitmapFilterQuality constants:
	 *                 <ul>
	 *                   <li><code>BitmapFilterQuality.LOW</code></li>
	 *                   <li><code>BitmapFilterQuality.MEDIUM</code></li>
	 *                   <li><code>BitmapFilterQuality.HIGH</code></li>
	 *                 </ul>
	 *
	 *                 <p>For more information, see the description of the
	 *                 <code>quality</code> property.</p>
	 * @param inner    Specifies whether the glow is an inner glow. The value
	 *                 <code> true</code> specifies an inner glow. The value
	 *                 <code>false</code> specifies an outer glow(a glow around
	 *                 the outer edges of the object).
	 * @param knockout Specifies whether the object has a knockout effect. The
	 *                 value <code>true</code> makes the object's fill
	 *                 transparent and reveals the background color of the
	 *                 document.
	 */
	function new(color : Int = 16711680, alpha : Float = 1, blurX : Float = 6, blurY : Float = 6, strength : Float = 2, quality : Int = 1, inner : Bool = false, knockout : Bool = false) : Void;
}


#end
