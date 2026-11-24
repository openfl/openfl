package openfl.ui;

#if !flash
#if !openfljs
/**
	The KeyboardType class is an enumeration class that provides values for
	different categories of physical computer or device keyboards.

	Use the values defined by the KeyboardType class with the
	`Keyboard.physicalKeyboardType` property.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract KeyboardType(Null<Int>)
{
	/**
		The keyboard has a standard keyboard layout, including letters, numbers
		and common punctuation.
	**/
	public var ALPHANUMERIC = 0;

	/**
		The keyboard consists of a standard telephone keypad, with the numbers
		0 through 9 and the `*` and `#` keys.
	**/
	public var KEYPAD = 1;

	/**
		No physical keyboard is supported.
	**/
	public var NONE = 2;

	@:from private static function fromString(value:String):KeyboardType
	{
		return switch (value)
		{
			case "alphanumeric": ALPHANUMERIC;
			case "keypad": KEYPAD;
			case "none": NONE;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : KeyboardType)
		{
			case KeyboardType.ALPHANUMERIC: "alphanumeric";
			case KeyboardType.KEYPAD: "keypad";
			case KeyboardType.NONE: "none";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment") #if (haxe_ver >= 4.0) enum #else @:enum #end abstract KeyboardType(String) from String to String
{
	public var ALPHANUMERIC = "alphanumeric";
	public var KEYPAD = "keypad";
	public var NONE = "none";
}
#end
#else
typedef KeyboardType = flash.ui.KeyboardType;
#end
