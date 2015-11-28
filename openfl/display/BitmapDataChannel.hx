package openfl.display; #if (!display && !flash)


class BitmapDataChannel {
	
	public static inline var ALPHA = 8;
	public static inline var BLUE = 4;
	public static inline var GREEN = 2;
	public static inline var RED = 1;
	
}


#else


/**
 * The BitmapDataChannel class is an enumeration of constant values that
 * indicate which channel to use: red, blue, green, or alpha transparency.
 *
 * <p>When you call some methods, you can use the bitwise OR operator
 * (<code>|</code>) to combine BitmapDataChannel constants to indicate
 * multiple color channels.</p>
 *
 * <p>The BitmapDataChannel constants are provided for use as values in the
 * following:</p>
 *
 * <ul>
 *   <li>The <code>sourceChannel</code> and <code>destChannel</code>
 * parameters of the <code>openfl.display.BitmapData.copyChannel()</code>
 * method</li>
 *   <li>The <code>channelOptions</code> parameter of the
 * <code>openfl.display.BitmapData.noise()</code> method</li>
 *   <li>The <code>openfl.filters.DisplacementMapFilter.componentX</code> and
 * <code>openfl.filters.DisplacementMapFilter.componentY</code> properties</li>
 * </ul>
 */

#if flash
@:native("flash.display.BitmapDataChannel")
#end

extern class BitmapDataChannel {
	
	/**
	 * The alpha channel.
	 */
	public static inline var ALPHA = 8;
	
	/**
	 * The blue channel.
	 */
	public static inline var BLUE = 4;
	
	/**
	 * The green channel.
	 */
	public static inline var GREEN = 2;
	
	/**
	 * The red channel.
	 */
	public static inline var RED = 1;
	
}


#end