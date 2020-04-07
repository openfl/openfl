package openfl.text.engine;

#if !flash

#if !openfljs
/**
	The FontWeight class is an enumeration of constant values used with `FontDescription.fontWeight`.
**/
@:enum abstract FontWeight(Null<Int>)
{
	/**
		Used to indicate bold font weight.
	**/
	public var BOLD = 0;

	/**
		Used to indicate normal font weight.
	**/
	public var NORMAL = 1;

	@:from private static function fromString(value:String):FontWeight
	{
		return switch (value)
		{
			case "bold": BOLD;
			case "normal": NORMAL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : FontWeight)
		{
			case FontWeight.BOLD: "bold";
			case FontWeight.NORMAL: "normal";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract FontWeight(String) from String to String
{
	public var BOLD = "bold";
	public var NORMAL = "normal";
}
#end
#else
typedef FontWeight = flash.text.engine.FontWeight;
#end
