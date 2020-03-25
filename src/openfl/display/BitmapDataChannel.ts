namespace openfl.display
{
	/**
	 * The BitmapDataChannel class is an enumeration of constant values that
	 * indicate which channel to use: red, blue, green, or alpha transparency.
	 *
	 * When you call some methods, you can use the bitwise OR operator
	 * (`|`) to combine BitmapDataChannel constants to indicate
	 * multiple color channels.
	 *
	 * The BitmapDataChannel constants are provided for use as values in the
	 * following:
	 *
	 *
	 *  * The `sourceChannel` and `destChannel`
	 * parameters of the `openfl.display.BitmapData.copyChannel()`
	 * method
	 *  * The `channelOptions` parameter of the
	 * `openfl.display.BitmapData.noise()` method
	 *  * The `openfl.filters.DisplacementMapFilter.componentX` and
	 * `openfl.filters.DisplacementMapFilter.componentY` properties
	 *
	 */
	export enum BitmapDataChannel
	{
		/**
		 * The alpha channel.
		 */
		ALPHA = 8,

		/**
		 * The blue channel.
		 */
		BLUE = 4,

		/**
		 * The green channel.
		 */
		GREEN = 2,

		/**
		 * The red channel.
		 */
		RED = 1
	}
}

export default openfl.display.BitmapDataChannel;
