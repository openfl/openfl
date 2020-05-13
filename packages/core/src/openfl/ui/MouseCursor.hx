package openfl.ui;

#if !flash
#if lime
import lime.ui.MouseCursor as LimeMouseCursor;
#end

/**
	The MouseCursor class is an enumeration of constant values used in setting
	the `cursor` property of the Mouse class.
**/
@:enum abstract MouseCursor(String) from String to String
{
	/**
		Used to specify that the arrow cursor should be used.
	**/
	public var ARROW = "arrow";

	/**
		Used to specify that the cursor should be selected automatically based
		on the object under the mouse.
	**/
	public var AUTO = "auto";

	/**
		Used to specify that the button pressing hand cursor should be used.
	**/
	public var BUTTON = "button";

	/**
		Used to specify that the dragging hand cursor should be used.
	**/
	public var HAND = "hand";

	/**
		Used to specify that the I-beam cursor should be used.
	**/
	public var IBEAM = "ibeam";

	#if lime
	@:from private static function fromLimeCursor(cursor:LimeMouseCursor):MouseCursor
	{
		var cursor:_MouseCursor = cursor;
		return cast cursor;
	}

	@:to private function toLimeCursor():LimeMouseCursor
	{
		var cursor:_MouseCursor = cast this;
		return cursor;
	}
	#end
}
#else
typedef MouseCursor = flash.ui.MouseCursor;
#end
