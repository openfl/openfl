package openfl.ui;


#if (lime >= "7.0.0")
import lime.app.Application;
import lime.ui.Cursor;
#else
import lime.ui.Mouse in LimeMouse;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

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
		
		#if (lime >= "7.0.0")
		for (window in Application.current.windows) {
			
			window.cursor = null;
			
		}
		#else
		LimeMouse.hide ();
		#end
		
	}
	
	
	public static function show ():Void {
		
		#if (lime >= "7.0.0")
		var cacheCursor = __cursor;
		__cursor = null;
		cursor = cacheCursor;
		#else
		LimeMouse.show ();
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private static function get_cursor ():MouseCursor {
		
		return __cursor;
		
	}
	
	
	private static function set_cursor (value:MouseCursor):MouseCursor {
		
		#if (lime >= "7.0.0")
		if (value == null) value = AUTO;
		var setCursor = null;
		
		switch (value) {
			
			case MouseCursor.ARROW: setCursor = ARROW;
			case MouseCursor.BUTTON: setCursor = POINTER;
			case MouseCursor.HAND: setCursor = MOVE;
			case MouseCursor.IBEAM: setCursor = TEXT;
			case MouseCursor.__CROSSHAIR: setCursor = CROSSHAIR;
			case MouseCursor.__CUSTOM: setCursor = CUSTOM;
			case MouseCursor.__RESIZE_NESW: setCursor = RESIZE_NESW;
			case MouseCursor.__RESIZE_NS: setCursor = RESIZE_NS;
			case MouseCursor.__RESIZE_NWSE: setCursor = RESIZE_NWSE;
			case MouseCursor.__RESIZE_WE: setCursor = RESIZE_WE;
			case MouseCursor.__WAIT: setCursor = WAIT;
			case MouseCursor.__WAIT_ARROW: setCursor = WAIT_ARROW;
			default:
			
		}
		
		if (setCursor != null) {
			
			for (window in Application.current.windows) {
				
				window.cursor = setCursor;
				
			}
			
		}
		#else
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
		#end
		
		return __cursor = value;
		
	}
	
	
}