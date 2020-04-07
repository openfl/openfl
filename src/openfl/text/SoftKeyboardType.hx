package openfl.text;

#if !flash

#if !openfljs
/**
	The SoftKeyboardType class defines the types of soft keyboards for mobile applications. You select the keyboard type with the `softKeyboardType` property on the text input control.
**/
@:enum abstract SoftKeyboardType(Null<Int>)
{
	/**
		A keypad designed for entering a person's name or phone number.
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
		A keyboard optimized for specifying email addresses.
	**/
	public var EMAIL = 3;

	/**
		A numeric keypad designed for PIN entry.
	**/
	public var NUMBER = 4;

	/**
		A keyboard optimized for entering phone numbers.
	**/
	public var PHONE = 5;

	/**
		A keyboard optimized for entering punctuation.
	**/
	public var PUNCTUATION = 6;

	/**
		A keyboard optimized for entering URLs.
	**/
	public var URL = 7;

	@:from private static function fromString(value:String):SoftKeyboardType
	{
		return switch (value)
		{
			case "contact": CONTACT;
			case "decimal": DECIMAL;
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
			case SoftKeyboardType.DECIMAL: "decimal";
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
@:enum abstract SoftKeyboardType(String) from String to String
{
	public var CONTACT = "contact";
	public var DECIMAL = "decimal";
	public var DEFAULT = "default";
	public var EMAIL = "email";
	public var NUMBER = "number";
	public var PHONE = "phone";
	public var PUNCTUATION = "punctuation";
	public var URL = "url";
}
#end
#else
typedef SoftKeyboardType = flash.text.SoftKeyboardType;
#end
