package flash.display;

#if flash
@:enum abstract BitmapDataChannel(UInt) from UInt to UInt from Int to Int
{
	public var ALPHA = 8;
	public var BLUE = 4;
	public var GREEN = 2;
	public var RED = 1;
}
#else
typedef BitmapDataChannel = openfl.display.BitmapDataChannel;
#end
