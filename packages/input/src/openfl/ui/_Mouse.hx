package openfl.ui;

import lime.app.Application;
import lime.ui.MouseCursor as LimeMouseCursor;
import openfl.display.Stage;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Stage)
@:noCompletion
class _Mouse
{
	public static var cursor(get, set):MouseCursor;
	public static var supportsCursor:Bool = #if !mobile true; #else false; #end
	public static var supportsNativeCursor:Bool = #if !mobile true; #else false; #end

	public static var __cursor:MouseCursor = MouseCursor.AUTO;
	public static var __hidden:Bool;

	public static function hide():Void
	{
		__hidden = true;
		for (window in Application.current.windows)
		{
			window.cursor = null;
		}
	}

	public static function show():Void
	{
		__hidden = false;
		var cacheCursor = __cursor;
		__cursor = null;
		cursor = cacheCursor;
	}

	public static function __setStageCursor(stage:Stage, cursor:MouseCursor):Void
	{
		var limeCursor:LimeMouseCursor = null;

		switch (cursor : String)
		{
			case MouseCursor.ARROW:
				limeCursor = ARROW;
			case MouseCursor.BUTTON:
				limeCursor = POINTER;
			case MouseCursor.HAND:
				limeCursor = MOVE;
			case MouseCursor.IBEAM:
				limeCursor = TEXT;
			case _MouseCursorExt.__CROSSHAIR:
				limeCursor = CROSSHAIR;
			case _MouseCursorExt.__CUSTOM:
				limeCursor = CUSTOM;
			case _MouseCursorExt.__RESIZE_NESW:
				limeCursor = RESIZE_NESW;
			case _MouseCursorExt.__RESIZE_NS:
				limeCursor = RESIZE_NS;
			case _MouseCursorExt.__RESIZE_NWSE:
				limeCursor = RESIZE_NWSE;
			case _MouseCursorExt.__RESIZE_WE:
				limeCursor = RESIZE_WE;
			case _MouseCursorExt.__WAIT:
				limeCursor = WAIT;
			case _MouseCursorExt.__WAIT_ARROW:
				limeCursor = WAIT_ARROW;
			default:
		}

		if (limeCursor != null && !__hidden)
		{
			stage.limeWindow.cursor = limeCursor;
		}
	}

	// Get & Set Methods

	public static function get_cursor():MouseCursor
	{
		return __cursor;
	}

	public static function set_cursor(value:MouseCursor):MouseCursor
	{
		if (value == null) value = AUTO;

		var limeCursor:LimeMouseCursor = null;

		switch (value : String)
		{
			case MouseCursor.ARROW:
				limeCursor = ARROW;
			case MouseCursor.BUTTON:
				limeCursor = POINTER;
			case MouseCursor.HAND:
				limeCursor = MOVE;
			case MouseCursor.IBEAM:
				limeCursor = TEXT;
			case _MouseCursorExt.__CROSSHAIR:
				limeCursor = CROSSHAIR;
			case _MouseCursorExt.__CUSTOM:
				limeCursor = CUSTOM;
			case _MouseCursorExt.__RESIZE_NESW:
				limeCursor = RESIZE_NESW;
			case _MouseCursorExt.__RESIZE_NS:
				limeCursor = RESIZE_NS;
			case _MouseCursorExt.__RESIZE_NWSE:
				limeCursor = RESIZE_NWSE;
			case _MouseCursorExt.__RESIZE_WE:
				limeCursor = RESIZE_WE;
			case _MouseCursorExt.__WAIT:
				limeCursor = WAIT;
			case _MouseCursorExt.__WAIT_ARROW:
				limeCursor = WAIT_ARROW;
			default:
		}

		if (limeCursor != null && !__hidden)
		{
			for (window in Application.current.windows)
			{
				window.cursor = limeCursor;
			}
		}

		return __cursor = value;
	}
}
