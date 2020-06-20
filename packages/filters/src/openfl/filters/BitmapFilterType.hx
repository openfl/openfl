package openfl.filters;

#if !flash
#if !openfljs
@:enum abstract BitmapFilterType(Null<Int>)
{
	public var FULL = 0;
	public var INNER = 1;
	public var OUTER = 2;

	@:from private static function fromString(value:String):BitmapFilterType
	{
		return switch (value)
		{
			case "full": FULL;
			case "inner": INNER;
			case "outer": OUTER;
			default: null;
		}
	}

	@:to private function toString():String
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
@:enum abstract BitmapFilterType(String) from String to String
{
	public var FULL = "full";
	public var INNER = "inner";
	public var OUTER = "outer";
}
#end
#else
typedef BitmapFilterType = flash.filters.BitmapFilterType;
#end
