package openfl.display;

#if !flash
/**
	The BitmapDataChannel class is an enumeration of constant values that
	indicate which channel to use: red, blue, green, or alpha transparency.

	When you call some methods, you can use the bitwise OR operator
	(`|`) to combine BitmapDataChannel constants to indicate
	multiple color channels.

	The BitmapDataChannel constants are provided for use as values in the
	following:

	* The `sourceChannel` and `destChannel`
	parameters of the `openfl.display.BitmapData.copyChannel()`
	method
	* The `channelOptions` parameter of the
	`openfl.display.BitmapData.noise()` method
	* The `openfl.filters.DisplacementMapFilter.componentX` and
	`openfl.filters.DisplacementMapFilter.componentY` properties

**/
@:enum abstract BitmapDataChannel(Int) from Int to Int from UInt to UInt
{
	/**
		The alpha channel.
	**/
	public var ALPHA = 8;

	/**
		The blue channel.
	**/
	public var BLUE = 4;

	/**
		The green channel.
	**/
	public var GREEN = 2;

	/**
		The red channel.
	**/
	public var RED = 1;
}
#else
typedef BitmapDataChannel = flash.display.BitmapDataChannel;
#end
