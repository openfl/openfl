package openfl.ui;


import lime.ui.Mouse in LimeMouse;
import openfl.Lib;

@:access(openfl.display.Stage)


@:final class Mouse {
	
	
	public static var cursor (get, set):String;
	public static var supportsCursor (default, null):Bool = #if !mobile true; #else false; #end
	public static var supportsNativeCursor (default, null):Bool = #if !mobile true; #else false; #end
	
	private static var __cursor:String = MouseCursor.AUTO;
	
	
	public static function hide ():Void {
		
		LimeMouse.hide ();
		
	}
	
	
	public static function show ():Void {
		
		LimeMouse.show ();
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private static function get_cursor ():String {
		
		return __cursor;
		
	}
	
	
	private static function set_cursor (value:String):String {
		
		switch (value) {
			
			case MouseCursor.ARROW: LimeMouse.cursor = ARROW;
			case MouseCursor.BUTTON: LimeMouse.cursor = POINTER;
			case MouseCursor.HAND: LimeMouse.cursor = MOVE;
			case MouseCursor.IBEAM: LimeMouse.cursor = TEXT;
			default:
			
		}
		
		return __cursor = value;
		
	}
	
	
}