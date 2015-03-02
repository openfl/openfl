package openfl.filters; #if !flash


/**
 * The BitmapFilterQuality class contains values to set the rendering quality
 * of a BitmapFilter object.
 */
class BitmapFilterQuality {
	
	
	/**
	 * Defines the high quality filter setting.
	 */
	public static var HIGH = 3;
	
	/**
	 * Defines the medium quality filter setting.
	 */
	public static var MEDIUM = 2;
	
	/**
	 * Defines the low quality filter setting.
	 */
	public static var LOW = 1;
	
	
}


#else
typedef BitmapFilterQuality = flash.filters.BitmapFilterQuality;
#end