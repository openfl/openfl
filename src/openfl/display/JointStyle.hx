package openfl.display;

#if !flash
#if !openfljs
@:enum abstract JointStyle(Null<Int>)
{
	public var BEVEL = 0;
	public var MITER = 1;
	public var ROUND = 2;

	@:noCompletion private inline static function fromInt(value:Null<Int>):JointStyle
	{
		return cast value;
	}

	@:from private static function fromString(value:String):JointStyle
	{
		return switch (value)
		{
			case "bevel": BEVEL;
			case "miter": MITER;
			case "round": ROUND;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : JointStyle)
		{
			case JointStyle.BEVEL: "bevel";
			case JointStyle.MITER: "miter";
			case JointStyle.ROUND: "round";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract JointStyle(String) from String to String
{
	public var BEVEL = "bevel";
	public var MITER = "miter";
	public var ROUND = "round";

	@:noCompletion private inline static function fromInt(value:Null<Int>):JointStyle
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
#end
#else
typedef JointStyle = flash.display.JointStyle;
#end
