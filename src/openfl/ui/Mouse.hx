package openfl.ui;


import lime.ui.Mouse in LimeMouse;

@:access(openfl.display.Stage)


@:final class Mouse {
	
	
	public static var cursor (get, set):MouseCursor;
	public static var supportsCursor (default, null):Bool = #if !mobile true; #else false; #end
	public static var supportsNativeCursor (default, null):Bool = #if !mobile true; #else false; #end
	
	private static var __cursor:MouseCursor = MouseCursor.AUTO;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (Mouse, "cursor", { get: function () { return Mouse.get_cursor (); }, set: function (value) { return Mouse.set_cursor (value); } });
		
	}
	#end
	
	
	public static function hide ():Void {
		
		LimeMouse.hide ();
		
	}
	
	
	public static function show ():Void {
		
		LimeMouse.show ();
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private static function get_cursor ():MouseCursor {
		
		return __cursor;
		
	}
	
	
	private static function set_cursor (value:MouseCursor):MouseCursor {
		
		switch (value) {
			
			case MouseCursor.ARROW: LimeMouse.cursor = ARROW;
			case MouseCursor.BUTTON: LimeMouse.cursor = POINTER;
			case MouseCursor.HAND: LimeMouse.cursor = MOVE;
			case MouseCursor.IBEAM: LimeMouse.cursor = TEXT;
			case MouseCursor.__CROSSHAIR: LimeMouse.cursor = CROSSHAIR;
			case MouseCursor.__CUSTOM: LimeMouse.cursor = CUSTOM;
			case MouseCursor.__RESIZE_NESW: LimeMouse.cursor = RESIZE_NESW;
			case MouseCursor.__RESIZE_NS: LimeMouse.cursor = RESIZE_NS;
			case MouseCursor.__RESIZE_NWSE: LimeMouse.cursor = RESIZE_NWSE;
			case MouseCursor.__RESIZE_WE: LimeMouse.cursor = RESIZE_WE;
			case MouseCursor.__WAIT: LimeMouse.cursor = WAIT;
			case MouseCursor.__WAIT_ARROW: LimeMouse.cursor = WAIT_ARROW;
			default:
			
		}
		
		return __cursor = value;
		
	}
	
	
}