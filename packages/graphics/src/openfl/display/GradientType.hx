package openfl.display;

#if !flash
#if !openfljs
@:enum abstract GradientType(Null<Int>)
{
	public var LINEAR = 0;
	public var RADIAL = 1;

	@:noCompletion private inline static function fromInt(value:Null<Int>):GradientType
	{
		return cast value;
	}

	@:from private static function fromString(value:String):GradientType
	{
		return switch (value)
		{
			case "linear": LINEAR;
			case "radial": RADIAL;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : GradientType)
		{
			case GradientType.LINEAR: "linear";
			case GradientType.RADIAL: "radial";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract GradientType(String) from String to String
{
	public var LINEAR = "linear";
	public var RADIAL = "radial";

	@:noCompletion private inline static function fromInt(value:Null<Int>):GradientType
	{
		return switch (value)
		{
			case 0: LINEAR;
			case 1: RADIAL;
			default: null;
		}
	}
}
#end
#else
typedef GradientType = flash.display.GradientType;
#end
