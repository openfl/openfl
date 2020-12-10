package openfl.ui;

#if !flash
#if lime
import lime.app.Application;
import lime.ui.MouseCursor as LimeMouseCursor;
#end

/**
	The methods of the Mouse class are used to hide and show the mouse pointer,
	or to set the pointer to a specific style. The Mouse class is a top-level
	class whose properties and methods you can access without using a
	constructor. <ph outputclass="flashonly">The pointer is visible by default,
	but you can hide it and implement a custom pointer.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Stage)
@:final class Mouse
{
	/**
		Sets or returns the type of cursor, or, for a native cursor, the
		cursor name.
		The default value is `openfl.ui.MouseCursor.AUTO`.

		To set values for this property, use the following string values:

		| String value | Description |
		| --- | --- |
		| `openfl.ui.MouseCursor.AUTO` | Mouse cursor will change automatically based on the object under the mouse. |
		| `openfl.ui.MouseCursor.ARROW` | Mouse cursor will be an arrow. |
		| `openfl.ui.MouseCursor.BUTTON` | Mouse cursor will be a button clicking hand. |
		| `openfl.ui.MouseCursor.HAND` | Mouse cursor will be a dragging hand. |
		| `openfl.ui.MouseCursor.IBEAM` | Mouse cursor will be an I-beam. |

		**Note:** For Flash Player 10.2 or AIR 2.6 and later versions, this
		property sets or gets the cursor name when you are using a native
		cursor. A native cursor name defined using `Mouse.registerCursor()`
		overwrites currently predefined cursor types (such as
		`openfl.ui.MouseCursor.IBEAM`).

		@throws ArgumentError If set to any value which is not a member of
							  `openfl.ui.MouseCursor`, or is not a string
							  specified using the `Mouse.registerCursor()`
							  method.
	**/
	public static var cursor(get, set):MouseCursor;

	/**
		Indicates whether the computer or device displays a persistent cursor.

		The `supportsCursor` property is `true` on most desktop computers and
		`false` on most mobile devices.

		**Note:** Mouse events can be dispatched whether or not this property
		is `true`. However, mouse events may behave differently depending on
		the physical characteristics of the pointing device.
	**/
	public static var supportsCursor(default, null):Bool = #if !mobile true; #else false; #end

	/**
		Indicates whether the current configuration supports native cursors.
	**/
	public static var supportsNativeCursor(default, null):Bool = #if !mobile true; #else false; #end

	@:noCompletion private static var __cursor:MouseCursor = MouseCursor.AUTO;
	@:noCompletion private static var __hidden:Bool;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(Mouse, "cursor", {
			get: function()
			{
				return Mouse.get_cursor();
			},
			set: function(value)
			{
				return Mouse.set_cursor(value);
			}
		});
	}
	#end

	/**
		Hides the pointer. The pointer is visible by default.

		**Note:** You need to call `Mouse.hide()` only once,
		regardless of the number of previous calls to
		`Mouse.show()`.

	**/
	public static function hide():Void
	{
		__hidden = true;

		#if lime
		for (window in Application.current.windows)
		{
			window.cursor = null;
		}
		#end
	}

	#if false
	/**
		Registers a native cursor under the given name, with the given data.

		@param name   The name to use as a reference to the native cursor
					  instance.
		@param cursor The properties for the native cursor, such as icon
					  bitmap, specified as a MouseCursorData instance.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_2) public static function registerCursor (name:String, cursor:openfl.ui.MouseCursorData):Void;
	#end

	/**
		Displays the pointer. The pointer is visible by default.

		**Note:** You need to call `Mouse.show()` only once,
		regardless of the number of previous calls to
		`Mouse.hide()`.

	**/
	public static function show():Void
	{
		__hidden = false;

		var cacheCursor = __cursor;
		__cursor = null;
		cursor = cacheCursor;
	}

	#if false
	/**
		Unregisters the native cursor with the given name.

		@param name The name referring to the native cursor instance.
	**/
	// @:noCompletion @:dox(hide) @:require(flash11) public static function unregisterCursor (name:String):Void;
	#end
	// Get & Set Methods
	@:noCompletion private static function get_cursor():MouseCursor
	{
		return __cursor;
	}

	@:noCompletion private static function set_cursor(value:MouseCursor):MouseCursor
	{
		if (value == null) value = AUTO;

		#if lime
		var setCursor:LimeMouseCursor = null;

		switch (value)
		{
			case MouseCursor.ARROW:
				setCursor = ARROW;
			case MouseCursor.BUTTON:
				setCursor = POINTER;
			case MouseCursor.HAND:
				setCursor = MOVE;
			case MouseCursor.IBEAM:
				setCursor = TEXT;
			case MouseCursor.__CROSSHAIR:
				setCursor = CROSSHAIR;
			case MouseCursor.__CUSTOM:
				setCursor = CUSTOM;
			case MouseCursor.__RESIZE_NESW:
				setCursor = RESIZE_NESW;
			case MouseCursor.__RESIZE_NS:
				setCursor = RESIZE_NS;
			case MouseCursor.__RESIZE_NWSE:
				setCursor = RESIZE_NWSE;
			case MouseCursor.__RESIZE_WE:
				setCursor = RESIZE_WE;
			case MouseCursor.__WAIT:
				setCursor = WAIT;
			case MouseCursor.__WAIT_ARROW:
				setCursor = WAIT_ARROW;
			default:
		}

		if (setCursor != null && !__hidden)
		{
			for (window in Application.current.windows)
			{
				window.cursor = setCursor;
			}
		}
		#end

		return __cursor = value;
	}
}
#else
typedef Mouse = flash.ui.Mouse;
#end
