package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract JointStyle(String) from String to String

{
	public var MITER = "miter";
	public var ROUND = "round";
	public var BEVEL = "bevel";

	@:noCompletion public inline static function fromInt(value:Null<Int>):JointStyle
	{
		return switch (value)
		{
			case 0: BEVEL;
			case 1: MITER;
			case 2: ROUND;
			default: null;
		}
	}
}
#else
typedef JointStyle = openfl.display.JointStyle;
#end
