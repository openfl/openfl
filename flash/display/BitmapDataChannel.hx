package flash.display;
#if (flash || display)


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
 * parameters of the <code>flash.display.BitmapData.copyChannel()</code>
 * method</li>
 *   <li>The <code>channelOptions</code> parameter of the
 * <code>flash.display.BitmapData.noise()</code> method</li>
 *   <li>The <code>flash.filters.DisplacementMapFilter.componentX</code> and
 * <code>flash.filters.DisplacementMapFilter.componentY</code> properties</li>
 * </ul>
 */
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
