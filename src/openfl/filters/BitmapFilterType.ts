namespace openfl.filters;

#if!flash

#if!openfljs
/**
	The BitmapFilterType class contains values to set the type of a
	BitmapFilter.
**/
@: enum abstract BitmapFilterType(null | number)
{
		/**
			Defines the setting that applies a filter to the entire area of an object.
		**/
		public FULL = 0;

		/**
			Defines the setting that applies a filter to the inner area of an object.
		**/
		public INNER = 1;

		/**
			Defines the setting that applies a filter to the outer area of an object.
		**/
		public OUTER = 2;

	@: from private static fromString(value: string): BitmapFilterType
	{
		return switch (value)
		{
			case "full": FULL;
			case "inner": INNER;
			case "outer": OUTER;
			default: null;
		}
	}

	@: to private toString(): string
	{
		return switch (cast this : BitmapFilterType)
		{
			case BitmapFilterType.FULL: "full";
			case BitmapFilterType.INNER: "inner";
			case BitmapFilterType.OUTER: "outer";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@: enum abstract BitmapFilterType(String) from String to String
{
	public FULL = "full";
	public INNER = "inner";
	public OUTER = "outer";
}
#end
#else
typedef BitmapFilterType = flash.filters.BitmapFilterType;
#end
