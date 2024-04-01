package openfl.text;

#if (!flash && sys)

#if !openfljs
/**
	The SoftKeyboardType class defines the types of soft keyboards for mobile
	applications. You select the keyboard type with the `softKeyboardType`
	property on the text input control.

	@see `openfl.text.StageText.softKeyboardType`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SoftKeyboardType(Null<Int>)

{
	/**
		A keypad designed for entering a person's name or phone number. This
		keyboard type does not support auto-capitalization.
	**/
	public var CONTACT = 0;

	/**
		A keyboard optimized for entering numbers along with a decimal.
	**/
	public var DECIMAL = 1;

	/**
		Default keyboard for the current input method.
	**/
	public var DEFAULT = 2;

	/**
		A keyboard optimized for specifying email addresses. This type features
		the "&", "." and space characters prominently.
	**/
	public var EMAIL = 3;

	/**
		A numeric keypad designed for PIN entry. This type features the numbers
		0 through 9 prominently. This keyboard type does not support
		auto-capitalization.
	**/
	public var NUMBER = 4;

	/**
		A keyboard optimized for entering phone numbers. This type features the
		numbers along with "+"," and "#" characters prominently.
	**/
	public var PHONE = 5;

	/**
		A keyboard optimized for entering punctuation.
	**/
	public var PUNCTUATION = 6;

	/**
		A keyboard optimized for entering URLs. This type features ".", "/",
		and ".com" prominently.
	**/
	public var URL = 7;

	@:from private static function fromString(value:String):SoftKeyboardType
	{
		return switch (value)
		{
			case "contact": CONTACT;
			case "decimalpad": DECIMAL;
			case "default": DEFAULT;
			case "email": EMAIL;
			case "number": NUMBER;
			case "phone": PHONE;
			case "punctuation": PUNCTUATION;
			case "url": URL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : SoftKeyboardType)
		{
			case SoftKeyboardType.CONTACT: "contact";
			case SoftKeyboardType.DECIMAL: "decimalpad";
			case SoftKeyboardType.DEFAULT: "default";
			case SoftKeyboardType.EMAIL: "email";
			case SoftKeyboardType.NUMBER: "number";
			case SoftKeyboardType.PHONE: "phone";
			case SoftKeyboardType.PUNCTUATION: "punctuation";
			case SoftKeyboardType.URL: "url";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SoftKeyboardType(String) from String to String

{
	public var CONTACT = "contact";
	public var DECIMAL = "decimalpad";
	public var DEFAULT = "default";
	public var EMAIL = "email";
	public var NUMBER = "number";
	public var PHONE = "phone";
	public var PUNCTUATION = "punctuation";
	public var URL = "url";
}
#end
#else
#if air
typedef SoftKeyboardType = flash.text.SoftKeyboardType;
#end
#end
