package openfl.text;

#if !flash

#if !openfljs
/**
	The GridFitType class defines values for grid fitting in the TextField
	class.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GridFitType(Null<Int>)

{
	/**
		Doesn't set grid fitting. Horizontal and vertical lines in the glyphs
		are not forced to the pixel grid. This constant is used in setting the
		`gridFitType` property of the TextField class. This is often a good
		setting for animation or for large font sizes. Use the syntax
		`GridFitType.NONE`.
	**/
	public var NONE = 0;

	/**
		Fits strong horizontal and vertical lines to the pixel grid. This
		constant is used in setting the `gridFitType` property of the
		TextField class. This setting only works for left-justified text
		fields and acts like the `GridFitType.SUBPIXEL` constant in static
		text. This setting generally provides the best readability for
		left-aligned text. Use the syntax `GridFitType.PIXEL`.
	**/
	public var PIXEL = 1;

	/**
		Fits strong horizontal and vertical lines to the sub-pixel grid on LCD
		monitors. (Red, green, and blue are actual pixels on an LCD screen.)
		This is often a good setting for right-aligned or center-aligned
		dynamic text, and it is sometimes a useful tradeoff for animation vs.
		text quality. This constant is used in setting the `gridFitType`
		property of the TextField class. Use the syntax
		`GridFitType.SUBPIXEL`.
	**/
	public var SUBPIXEL = 2;

	@:from private static function fromString(value:String):GridFitType
	{
		return switch (value)
		{
			case "none": NONE;
			case "pixel": PIXEL;
			case "subpixel": SUBPIXEL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : GridFitType)
		{
			case GridFitType.NONE: "none";
			case GridFitType.PIXEL: "pixel";
			case GridFitType.SUBPIXEL: "subpixel";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GridFitType(String) from String to String

{
	public var NONE = "none";
	public var PIXEL = "pixel";
	public var SUBPIXEL = "subpixel";
}
#end
#else
typedef GridFitType = flash.text.GridFitType;
#end
