package flash.ui; #if flash


#if (lime >= "7.0.0")
import lime.ui.Cursor;
#else
import lime.ui.MouseCursor in Cursor;
#end


@:enum abstract MouseCursor(String) from String to String {
	
	public var ARROW = "arrow";
	public var AUTO = "auto";
	public var BUTTON = "button";
	public var HAND = "hand";
	public var IBEAM = "ibeam";
	
	@:from private static function fromLimeCursor (cursor:Cursor):MouseCursor {
		
		return switch (cursor) {
			
			case Cursor.ARROW: MouseCursor.ARROW;
			case Cursor.DEFAULT: MouseCursor.AUTO;
			case Cursor.POINTER: MouseCursor.BUTTON;
			case Cursor.MOVE: MouseCursor.HAND;
			case Cursor.TEXT: MouseCursor.IBEAM;
			default: MouseCursor.AUTO;
			
		}
		
	}
	
}


#else
typedef MouseCursor = openfl.ui.MouseCursor;
#end