package openfl.display;

#if !flash
#if !openfljs
@:enum abstract InterpolationMethod(Null<Int>)
{
	public var LINEAR_RGB = 0;
	public var RGB = 1;

	@:noCompletion private inline static function fromInt(value:Null<Int>):InterpolationMethod
	{
		return cast value;
	}

	@:from private static function fromString(value:String):InterpolationMethod
	{
		return switch (value)
		{
			case "linearRGB": LINEAR_RGB;
			case "rgb": RGB;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : InterpolationMethod)
		{
			case InterpolationMethod.LINEAR_RGB: "linearRGB";
			case InterpolationMethod.RGB: "rgb";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract InterpolationMethod(String) from String to String
{
	public var LINEAR_RGB = "linearRGB";
	public var RGB = "rgb";

	@:noCompletion private inline static function fromInt(value:Null<Int>):InterpolationMethod
	{
		return switch (value)
		{
			case 0: LINEAR_RGB;
			case 1: RGB;
			default: null;
		}
	}
}
#end
#else
typedef InterpolationMethod = flash.display.InterpolationMethod;
#end
