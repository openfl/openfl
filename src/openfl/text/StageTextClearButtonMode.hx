package openfl.text;

#if !flash

#if !openfljs
/**
	This class defines an enumeration that provides option for clearButton.
**/
@:enum abstract StageTextClearButtonMode(Null<Int>)
{
	/**
		StageText clearButton is always shown
	**/
	public var ALWAYS = 0;

	/**
		StageText clearButton is never shown
	**/
	public var NEVER = 1;

	/**
		StageText clearButton is not shown while editing
	**/
	public var UNLESS_EDITING = 2;

	/**
		StageText clearButton is visible while editing
	**/
	public var WHILE_EDITING = 3;

	@:from private static function fromString(value:String):StageTextClearButtonMode
	{
		return switch (value)
		{
			case "always": ALWAYS;
			case "never": NEVER;
			case "unlessEditing": UNLESS_EDITING;
			case "whileEditing": WHILE_EDITING;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : StageTextClearButtonMode)
		{
			case StageTextClearButtonMode.ALWAYS: "always";
			case StageTextClearButtonMode.NEVER: "never";
			case StageTextClearButtonMode.UNLESS_EDITING: "unlessEditing";
			case StageTextClearButtonMode.WHILE_EDITING: "whileEditing";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract StageTextClearButtonMode(String) from String to String
{
	public var ALWAYS = "always";
	public var NEVER = "never";
	public var UNLESS_EDITING = "unlessEditing";
	public var WHILE_EDITING = "whileEditing";
}
#end
#else
typedef StageTextClearButtonMode = flash.text.StageTextClearButtonMode;
#end
