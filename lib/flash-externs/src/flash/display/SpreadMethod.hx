package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SpreadMethod(String) from String to String

{
	public var PAD = "pad";
	public var REFLECT = "reflect";
	public var REPEAT = "repeat";

	@:noCompletion public inline static function fromInt(value:Null<Int>):SpreadMethod
	{
		return switch (value)
		{
			case 0: PAD;
			case 1: REFLECT;
			case 2: REPEAT;
			default: null;
		}
	}
}
#else
typedef SpreadMethod = openfl.display.SpreadMethod;
#end
