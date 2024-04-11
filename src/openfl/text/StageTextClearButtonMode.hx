package openfl.text;

#if (!flash && sys)

#if !openfljs
/**
	The StageTextClearButtonMode class defines the values to use for the
	`clearButtonMode` property of the StageText class.

	@see `openfl.text.StageText.clearButtonMode`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageTextClearButtonMode(Null<Int>)

{
	/**
		The StageText clear button is always shown.
	**/
	public var ALWAYS = 0;

	/**
		The StageText clear button is never shown.
	**/
	public var NEVER = 1;

	/**
		The StageText clear button is not visible while editing.
	**/
	public var UNLESS_EDITING = 2;

	/**
		The StageText clear button is visible while editing.
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
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageTextClearButtonMode(String) from String to String

{
	public var ALWAYS = "default";
	public var NEVER = "done";
	public var UNLESS_EDITING = "unlessEditing";
	public var WHILE_EDITING = "whileEditing";
}
#end
#else
#if air
typedef StageTextClearButtonMode = flash.text.StageTextClearButtonMode;
#end
#end
