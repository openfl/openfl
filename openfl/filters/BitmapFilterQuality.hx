package openfl.filters; #if (!display && !flash)


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


/**
 * The BitmapFilterQuality class contains values to set the rendering quality
 * of a BitmapFilter object.
 */

#if flash
@:native("flash.filters.BitmapFilterQuality")
#end


extern class BitmapFilterQuality {
	
	
	/**
	 * Defines the high quality filter setting.
	 */
	public static var HIGH:Int;
	
	/**
	 * Defines the medium quality filter setting.
	 */
	public static var MEDIUM:Int;
	
	/**
	 * Defines the low quality filter setting.
	 */
	public static var LOW:Int;
	
	
}


#end