package openfl.ui; #if !flash


import lime.app.Application;
import lime.ui.MouseCursor as LimeMouseCursor;


/**
 * The methods of the Mouse class are used to hide and show the mouse pointer,
 * or to set the pointer to a specific style. The Mouse class is a top-level
 * class whose properties and methods you can access without using a
 * constructor. <ph outputclass="flashonly">The pointer is visible by default,
 * but you can hide it and implement a custom pointer.
 */

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Stage)


@:final class Mouse {
	
	
	public static var cursor (get, set):MouseCursor;
	public static var supportsCursor (default, null):Bool = #if !mobile true; #else false; #end
	public static var supportsNativeCursor (default, null):Bool = #if !mobile true; #else false; #end
	
	@:noCompletion private static var __cursor:MouseCursor = MouseCursor.AUTO;
	@:noCompletion private static var __hidden:Bool;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperty (Mouse, "cursor", { get: function () { return Mouse.get_cursor (); }, set: function (value) { return Mouse.set_cursor (value); } });
		
	}
	#end
	
	
	/**
	 * Hides the pointer. The pointer is visible by default.
	 *
	 * **Note:** You need to call `Mouse.hide()` only once,
	 * regardless of the number of previous calls to
	 * `Mouse.show()`.
	 * 
	 */
	public static function hide ():Void {
		
		__hidden = true;
		
		for (window in Application.current.windows) {
			
			window.cursor = null;
			
		}
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash10_2) public static function registerCursor (name:String, cursor:flash.ui.MouseCursorData):Void;
	
	
	/**
	 * Displays the pointer. The pointer is visible by default.
	 *
	 * **Note:** You need to call `Mouse.show()` only once,
	 * regardless of the number of previous calls to
	 * `Mouse.hide()`.
	 * 
	 */
	public static function show ():Void {
		
		__hidden = false;
		
		var cacheCursor = __cursor;
		__cursor = null;
		cursor = cacheCursor;
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash11) public static function unregisterCursor (name:String):Void;
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private static function get_cursor ():MouseCursor {
		
		return __cursor;
		
	}
	
	
	@:noCompletion private static function set_cursor (value:MouseCursor):MouseCursor {
		
		if (value == null) value = AUTO;
		var setCursor:LimeMouseCursor = null;
		
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
		
		if (setCursor != null && !__hidden) {
			
			for (window in Application.current.windows) {
				
				window.cursor = setCursor;
				
			}
			
		}
		
		return __cursor = value;
		
	}
	
	
}


#else
typedef Mouse = flash.ui.Mouse;
#end