package flash.filters {
	
	
	/**
	 * @externs
	 * The DropShadowFilter class lets you add a drop shadow to display objects.
	 * The shadow algorithm is based on the same box filter that the blur filter
	 * uses. You have several options for the style of the drop shadow, including
	 * inner or outer shadow and knockout mode. You can apply the filter to any
	 * display object(that is, objects that inherit from the DisplayObject
	 * class), such as MovieClip, SimpleButton, TextField, and Video objects, as
	 * well as to BitmapData objects.
	 *
	 * The use of filters depends on the object to which you apply the
	 * filter:
	 *
	 * 
	 *  * To apply filters to display objects use the `filters`
	 * property(inherited from DisplayObject). Setting the `filters`
	 * property of an object does not modify the object, and you can remove the
	 * filter by clearing the `filters` property. 
	 *  * To apply filters to BitmapData objects, use the
	 * `BitmapData.applyFilter()` method. Calling
	 * `applyFilter()` on a BitmapData object takes the source
	 * BitmapData object and the filter object and generates a filtered image as a
	 * result.
	 * 
	 *
	 * If you apply a filter to a display object, the value of the
	 * `cacheAsBitmap` property of the display object is set to
	 * `true`. If you clear all filters, the original value of
	 * `cacheAsBitmap` is restored.
	 *
	 * This filter supports Stage scaling. However, it does not support general
	 * scaling, rotation, and skewing. If the object itself is scaled(if
	 * `scaleX` and `scaleY` are set to a value other than
	 * 1.0), the filter is not scaled. It is scaled only when the user zooms in on
	 * the Stage.
	 *
	 * A filter is not applied if the resulting image exceeds the maximum
	 * dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
	 * width or height, and the total number of pixels cannot exceed 16,777,215
	 * pixels.(So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
	 * high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
	 * limitation is 2,880 pixels in height and 2,880 pixels in width. If, for
	 * example, you zoom in on a large movie clip with a filter applied, the
	 * filter is turned off if the resulting image exceeds the maximum
	 * dimensions.
	 */
	final public class DropShadowFilter extends BitmapFilter {
		
		
		/**
		 * The alpha transparency value for the shadow color. Valid values are 0.0 to
		 * 1.0. For example, .25 sets a transparency value of 25%. The default value
		 * is 1.0.
		 */
		public var alpha:Number;
		
		/**
		 * The angle of the shadow. Valid values are 0 to 360 degrees(floating
		 * point). The default value is 45.
		 */
		public var angle:Number;
		
		/**
		 * The amount of horizontal blur. Valid values are 0 to 255.0(floating
		 * point). The default value is 4.0.
		 */
		public var blurX:Number;
		
		/**
		 * The amount of vertical blur. Valid values are 0 to 255.0(floating point).
		 * The default value is 4.0.
		 */
		public var blurY:Number;
		
		/**
		 * The color of the shadow. Valid values are in hexadecimal format
		 * _0xRRGGBB_. The default value is 0x000000.
		 */
		public var color:int;
		
		/**
		 * The offset distance for the shadow, in pixels. The default value is 4.0
		 * (floating point).
		 */
		public var distance:Number;
		
		/**
		 * Indicates whether or not the object is hidden. The value `true`
		 * indicates that the object itself is not drawn; only the shadow is visible.
		 * The default is `false`(the object is shown).
		 */
		public var hideObject:Boolean;
		
		/**
		 * Indicates whether or not the shadow is an inner shadow. The value
		 * `true` indicates an inner shadow. The default is
		 * `false`, an outer shadow(a shadow around the outer edges of
		 * the object).
		 */
		public var inner:Boolean;
		
		/**
		 * Applies a knockout effect(`true`), which effectively makes the
		 * object's fill transparent and reveals the background color of the
		 * document. The default is `false`(no knockout).
		 */
		public var knockout:Boolean;
		
		/**
		 * The number of times to apply the filter. The default value is
		 * `BitmapFilterQuality.LOW`, which is equivalent to applying the
		 * filter once. The value `BitmapFilterQuality.MEDIUM` applies the
		 * filter twice; the value `BitmapFilterQuality.HIGH` applies it
		 * three times. Filters with lower values are rendered more quickly.
		 *
		 * For most applications, a quality value of low, medium, or high is
		 * sufficient. Although you can use additional numeric values up to 15 to
		 * achieve different effects, higher values are rendered more slowly. Instead
		 * of increasing the value of `quality`, you can often get a
		 * similar effect, and with faster rendering, by simply increasing the values
		 * of the `blurX` and `blurY` properties.
		 */
		public var quality:int;
		
		/**
		 * The strength of the imprint or spread. The higher the value, the more
		 * color is imprinted and the stronger the contrast between the shadow and
		 * the background. Valid values are from 0 to 255.0. The default is 1.0.
		 */
		public var strength:Number;
		
		
		/**
		 * Creates a new DropShadowFilter instance with the specified parameters.
		 * 
		 * @param distance   Offset distance for the shadow, in pixels.
		 * @param angle      Angle of the shadow, 0 to 360 degrees(floating point).
		 * @param color      Color of the shadow, in hexadecimal format
		 *                   _0xRRGGBB_. The default value is 0x000000.
		 * @param alpha      Alpha transparency value for the shadow color. Valid
		 *                   values are 0.0 to 1.0. For example, .25 sets a
		 *                   transparency value of 25%.
		 * @param blurX      Amount of horizontal blur. Valid values are 0 to 255.0
		 *                  (floating point).
		 * @param blurY      Amount of vertical blur. Valid values are 0 to 255.0
		 *                  (floating point).
		 * @param strength   The strength of the imprint or spread. The higher the
		 *                   value, the more color is imprinted and the stronger the
		 *                   contrast between the shadow and the background. Valid
		 *                   values are 0 to 255.0.
		 * @param quality    The number of times to apply the filter. Use the
		 *                   BitmapFilterQuality constants:
		 *                   
		 *                    * `BitmapFilterQuality.LOW`
		 *                    * `BitmapFilterQuality.MEDIUM`
		 *                    * `BitmapFilterQuality.HIGH`
		 *                   
		 *
		 *                   For more information about these values, see the
		 *                   `quality` property description.
		 * @param inner      Indicates whether or not the shadow is an inner shadow.
		 *                   A value of `true` specifies an inner shadow.
		 *                   A value of `false` specifies an outer shadow
		 *                  (a shadow around the outer edges of the object).
		 * @param knockout   Applies a knockout effect(`true`), which
		 *                   effectively makes the object's fill transparent and
		 *                   reveals the background color of the document.
		 * @param hideObject Indicates whether or not the object is hidden. A value
		 *                   of `true` indicates that the object itself is
		 *                   not drawn; only the shadow is visible.
		 */
		public function DropShadowFilter (distance:Number = 4, angle:Number = 45, color:int = 0, alpha:Number = 1, blurX:Number = 4, blurY:Number = 4, strength:Number = 1, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false) {}
		
		
	}
	
	
}