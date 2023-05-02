package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract LineScaleMode(String) from String to String

{
	public var HORIZONTAL = "horizontal";
	public var NONE = "none";
	public var NORMAL = "normal";
	public var VERTICAL = "vertical";

	@:noCompletion public inline static function fromInt(value:Null<Int>):LineScaleMode
	{
		return switch (value)
		{
			case 0: HORIZONTAL;
			case 1: NONE;
			case 2: NORMAL;
			case 3: VERTICAL;
			default: null;
		}
	}
}
#else
typedef LineScaleMode = openfl.display.LineScaleMode;
#end
