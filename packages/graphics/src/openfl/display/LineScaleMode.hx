package openfl.display;

#if !flash
#if !openfljs
@:enum abstract LineScaleMode(Null<Int>)
{
	public var HORIZONTAL = 0;
	public var NONE = 1;
	public var NORMAL = 2;
	public var VERTICAL = 3;

	@:noCompletion private inline static function fromInt(value:Null<Int>):LineScaleMode
	{
		return cast value;
	}

	@:from private static function fromString(value:String):LineScaleMode
	{
		return switch (value)
		{
			case "horizontal": HORIZONTAL;
			case "none": NONE;
			case "normal": NORMAL;
			case "vertical": VERTICAL;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : LineScaleMode)
		{
			case LineScaleMode.HORIZONTAL: "horizontal";
			case LineScaleMode.NONE: "none";
			case LineScaleMode.NORMAL: "normal";
			case LineScaleMode.VERTICAL: "vertical";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract LineScaleMode(String) from String to String
{
	public var HORIZONTAL = "horizontal";
	public var NONE = "none";
	public var NORMAL = "normal";
	public var VERTICAL = "vertical";

	@:noCompletion private inline static function fromInt(value:Null<Int>):LineScaleMode
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
#end
#else
typedef LineScaleMode = flash.display.LineScaleMode;
#end
