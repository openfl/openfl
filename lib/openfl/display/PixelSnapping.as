package openfl.display {
	
	
	/**
	 * @externs
	 * The PixelSnapping class is an enumeration of constant values for setting
	 * the pixel snapping options by using the `pixelSnapping` property
	 * of a Bitmap object.
	 */
	final public class PixelSnapping {
		
		/**
		 * A constant value used in the `pixelSnapping` property of a
		 * Bitmap object to specify that the bitmap image is always snapped to the
		 * nearest pixel, independent of any transformation.
		 */
		public static const ALWAYS:String = "always";
		
		/**
		 * A constant value used in the `pixelSnapping` property of a
		 * Bitmap object to specify that the bitmap image is snapped to the nearest
		 * pixel if it is drawn with no rotation or skew and it is drawn at a scale
		 * factor of 99.9% to 100.1%. If these conditions are satisfied, the image is
		 * drawn at 100% scale, snapped to the nearest pixel. Internally, this
		 * setting allows the image to be drawn as fast as possible by using the
		 * vector renderer.
		 */
		public static const AUTO:String = "auto";
		
		/**
		 * A constant value used in the `pixelSnapping` property of a
		 * Bitmap object to specify that no pixel snapping occurs.
		 */
		public static const NEVER:String = "never";
		
	}
	
	
}