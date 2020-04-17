/**
	The BitmapFilterType class contains values to set the type of a
	BitmapFilter.
**/
export enum BitmapFilterType
{
	/**
		Defines the setting that applies a filter to the entire area of an object.
	**/
	FULL = 0,

	/**
		Defines the setting that applies a filter to the inner area of an object.
	**/
	INNER = 1,

	/**
		Defines the setting that applies a filter to the outer area of an object.
	**/
	OUTER = 2
}

export default BitmapFilterType;
