package openfl.display {
	
	
	/**
	* @externs
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
	final public class BitmapDataChannel {
		
		/**
		* The alpha channel.
		*/
		public static const ALPHA:uint = 8;
		
		/**
		* The blue channel.
		*/
		public static const BLUE:uint = 4;
		
		/**
		* The green channel.
		*/
		public static const GREEN:uint = 2;
		
		/**
		* The red channel.
		*/
		public static const RED:uint = 1;
		
	}
	
	
}