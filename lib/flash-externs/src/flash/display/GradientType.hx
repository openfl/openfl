package flash.display;

#if flash
@:enum abstract GradientType(String) from String to String
{
	public var LINEAR = "linear";
	public var RADIAL = "radial";

	@:noCompletion public inline static function fromInt(value:Null<Int>):GradientType
	{
		return switch (value)
		{
			case 0: LINEAR;
			case 1: RADIAL;
			default: null;
		}
	}
}
#else
typedef GradientType = openfl.display.GradientType;
#end
