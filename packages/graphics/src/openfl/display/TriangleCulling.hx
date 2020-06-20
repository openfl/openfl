package openfl.display;

#if !flash
#if !openfljs
@:enum abstract TriangleCulling(Null<Int>)
{
	public var NEGATIVE = 0;
	public var NONE = 1;
	public var POSITIVE = 2;

	@:from private static function fromString(value:String):TriangleCulling
	{
		return switch (value)
		{
			case "negative": NEGATIVE;
			case "none": NONE;
			case "positive": POSITIVE;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : TriangleCulling)
		{
			case TriangleCulling.NEGATIVE: "negative";
			case TriangleCulling.NONE: "none";
			case TriangleCulling.POSITIVE: "positive";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract TriangleCulling(String) from String to String
{
	public var NEGATIVE = "negative";
	public var NONE = "none";
	public var POSITIVE = "positive";
}
#end
#else
typedef TriangleCulling = flash.display.TriangleCulling;
#end
