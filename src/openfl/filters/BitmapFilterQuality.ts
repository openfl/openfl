namespace openfl.filters;

#if!flash
/**
	The BitmapFilterQuality class contains values to set the rendering quality
	of a BitmapFilter object.
**/
@: enum abstract BitmapFilterQuality(Int) from Int to Int from UInt to UInt
{
	/**
		Defines the high quality filter setting.
	**/
	public HIGH = 3;

	/**
		Defines the medium quality filter setting.
	**/
	public MEDIUM = 2;

	/**
		Defines the low quality filter setting.
	**/
	public LOW = 1;
}
#else
typedef BitmapFilterQuality = flash.filters.BitmapFilterQuality;
#end
