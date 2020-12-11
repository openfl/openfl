package openfl.display;

#if !flash

#if !openfljs
/**
	The GraphicsPathWinding class provides values for the
	`openfl.display.GraphicsPath.winding` property and the
	`openfl.display.Graphics.drawPath()` method to determine the
	direction to draw a path. A clockwise path is positively wound, and a
	counter-clockwise path is negatively wound:

	![positive and negative winding directions](/images/winding_positive_negative.gif)

	When paths intersect or overlap, the winding direction determines the
	rules for filling the areas created by the intersection or overlap:

	![a comparison of even-odd and non-zero winding rules](/images/winding_rules_evenodd_nonzero.gif)
**/
@:enum abstract GraphicsPathWinding(Null<Int>)
{
	/**
		Establishes the even-odd winding type. The even-odd winding type is the rule
		used by all of the original drawing API and is the default type for the
		`openfl.display.Graphics.drawPath()` method. Any overlapping paths will
		alternate between open and closed fills. If two squares drawn with the same
		fill intersect, the area of the intersection is not filled. Adjacent areas are not
		the same (neither both filled nor both unfilled).
	**/
	public var EVEN_ODD = 0;

	/**
		Establishes the non-zero winding type. The non-zero winding type determines that
		when paths of opposite winding intersect, the intersection area is unfilled
		(as with the even-odd winding type). For paths of the same winding, the
		intersection area is filled.
	**/
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
