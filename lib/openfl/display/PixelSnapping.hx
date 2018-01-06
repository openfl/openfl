package openfl.display; #if (display || !flash)


/**
 * The PixelSnapping class is an enumeration of constant values for setting
 * the pixel snapping options by using the `pixelSnapping` property
 * of a Bitmap object.
 */
@:enum abstract PixelSnapping(Null<Int>) {
	
	/**
	 * A constant value used in the `pixelSnapping` property of a
	 * Bitmap object to specify that the bitmap image is always snapped to the
	 * nearest pixel, independent of any transformation.
	 */
	public var ALWAYS = 0;
	
	/**
	 * A constant value used in the `pixelSnapping` property of a
	 * Bitmap object to specify that the bitmap image is snapped to the nearest
	 * pixel if it is drawn with no rotation or skew and it is drawn at a scale
	 * factor of 99.9% to 100.1%. If these conditions are satisfied, the image is
	 * drawn at 100% scale, snapped to the nearest pixel. Internally, this
	 * setting allows the image to be drawn as fast as possible by using the
	 * vector renderer.
	 */
	public var AUTO = 1;
	
	/**
	 * A constant value used in the `pixelSnapping` property of a
	 * Bitmap object to specify that no pixel snapping occurs.
	 */
	public var NEVER = 2;
	
	@:from private static function fromString (value:String):PixelSnapping {
		
		return switch (value) {
			
			case "always": ALWAYS;
			case "auto": AUTO;
			case "never": NEVER;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case PixelSnapping.ALWAYS: "always";
			case PixelSnapping.AUTO: "auto";
			case PixelSnapping.NEVER: "never";
			default: null;
			
		}
		
	}
	
}


#else
typedef PixelSnapping = flash.display.PixelSnapping;
#end