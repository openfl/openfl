package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract CapsStyle(String) from String to String

{
	public var NONE = "none";
	public var ROUND = "round";
	public var SQUARE = "square";

	@:noCompletion public inline static function fromInt(value:Null<Int>):CapsStyle
	{
		return switch (value)
		{
			case 0: NONE;
			case 1: ROUND;
			case 2: SQUARE;
			default: null;
		}
	}
}
#else
typedef CapsStyle = openfl.display.CapsStyle;
#end
