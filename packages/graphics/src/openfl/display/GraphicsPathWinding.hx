package openfl.display;

#if !flash
#if !openfljs
@:enum abstract GraphicsPathWinding(Null<Int>)
{
	public var EVEN_ODD = 0;
	public var NON_ZERO = 1;

	@:from private static function fromString(value:String):GraphicsPathWinding
	{
		return switch (value)
		{
			case "evenOdd": EVEN_ODD;
			case "nonZero": NON_ZERO;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : GraphicsPathWinding)
		{
			case GraphicsPathWinding.EVEN_ODD: "evenOdd";
			case GraphicsPathWinding.NON_ZERO: "nonZero";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract GraphicsPathWinding(String) from String to String
{
	public var EVEN_ODD = "evenOdd";
	public var NON_ZERO = "nonZero";
}
#end
#else
typedef GraphicsPathWinding = flash.display.GraphicsPathWinding;
#end
