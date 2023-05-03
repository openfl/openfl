package openfl.text;

#if !flash

#if !openfljs
/**
	The AntiAliasType class provides values for anti-aliasing in the
	openfl.text.TextField class.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AntiAliasType(Null<Int>)

{
	/**
		Sets anti-aliasing to advanced anti-aliasing. Advanced anti-aliasing
		allows font faces to be rendered at very high quality at small sizes. It
		is best used with applications that have a lot of small text. Advanced
		anti-aliasing is not recommended for very large fonts(larger than 48
		points). This constant is used for the `antiAliasType` property
		in the TextField class. Use the syntax
		`AntiAliasType.ADVANCED`.
	**/
	public var ADVANCED = 0;

	/**
		Sets anti-aliasing to the anti-aliasing that is used in Flash Player 7 and
		earlier. This setting is recommended for applications that do not have a
		lot of text. This constant is used for the `antiAliasType`
		property in the TextField class. Use the syntax
		`AntiAliasType.NORMAL`.
	**/
	public var NORMAL = 1;

	@:from private static function fromString(value:String):AntiAliasType
	{
		return switch (value)
		{
			case "advanced": ADVANCED;
			case "normal": NORMAL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : AntiAliasType)
		{
			case AntiAliasType.ADVANCED: "advanced";
			case AntiAliasType.NORMAL: "normal";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AntiAliasType(String) from String to String

{
	public var ADVANCED = "advanced";
	public var NORMAL = "normal";
}
#end
#else
typedef AntiAliasType = flash.text.AntiAliasType;
#end
