package openfl.display;

#if (!flash && sys)

#if !openfljs
/**
	The FocusDirection class enumerates values to be used for the `direction`
	parameter of the `assignFocus()` method of a Stage object and for the
	`direction` property of a FocusEvent object.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract FocusDirection(Null<Int>)

{
	/**
		Indicates that focus should be given to the object at the end of the
		reading order.
	**/
	public var BOTTOM = 0;

	/**
		Indicates that focus object within the interactive object should not
		change.
	**/
	public var NONE = 1;

	/**
		Indicates that focus should be given to the object at the beginning of
		the reading order.
	**/
	public var TOP = 2;

	@:from private static function fromString(value:String):FocusDirection
	{
		return switch (value)
		{
			case "bottom": BOTTOM;
			case "none": NONE;
			case "top": TOP;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : FocusDirection)
		{
			case FocusDirection.BOTTOM: "bottom";
			case FocusDirection.NONE: "none";
			case FocusDirection.TOP: "top";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract FocusDirection(String) from String to String

{
	public var BOTTOM = "bottom";
	public var NONE = "none";
	public var TOP = "top";
}
#end
#else
#if air
typedef FocusDirection = flash.display.FocusDirection;
#end
#end
