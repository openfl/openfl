package flash.ui;

#if flash
import lime.ui.MouseCursor in LimeMouseCursor;

@:enum abstract MouseCursor(String) from String to String
{
	public var ARROW = "arrow";
	public var AUTO = "auto";
	public var BUTTON = "button";
	public var HAND = "hand";
	public var IBEAM = "ibeam";

	@:from private static function fromLimeCursor(cursor:LimeMouseCursor):MouseCursor
	{
		return switch (cursor)
		{
			case LimeMouseCursor.ARROW: MouseCursor.ARROW;
			case LimeMouseCursor.DEFAULT: MouseCursor.AUTO;
			case LimeMouseCursor.POINTER: MouseCursor.BUTTON;
			case LimeMouseCursor.MOVE: MouseCursor.HAND;
			case LimeMouseCursor.TEXT: MouseCursor.IBEAM;
			default: MouseCursor.AUTO;
		}
	}
}
#else
typedef MouseCursor = openfl.ui.MouseCursor;
#end
