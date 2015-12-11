package openfl.filters;


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