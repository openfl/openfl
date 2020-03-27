import Stage from "../display/Stage";
import MouseCursor from "../ui/MouseCursor";

/**
	The methods of the Mouse class are used to hide and show the mouse pointer,
	or to set the pointer to a specific style. The Mouse class is a top-level
	class whose properties and methods you can access without using a
	constructor. <ph outputclass="flashonly">The pointer is visible by default,
	but you can hide it and implement a custom pointer.
**/
export default class Mouse
{
	/**
		Indicates whether the computer or device displays a persistent cursor.

		The `supportsCursor` property is `true` on most desktop computers and
		`false` on most mobile devices.

		**Note:** Mouse events can be dispatched whether or not this property
		is `true`. However, mouse events may behave differently depending on
		the physical characteristics of the pointing device.
	**/
	public static readonly supportsCursor: boolean = true;

	/**
		Indicates whether the current configuration supports native cursors.
	**/
	public static readonly supportsNativeCursor: boolean = false;

	protected static __cursor: MouseCursor = MouseCursor.AUTO;
	protected static __hidden: boolean;

	/**
		Hides the pointer. The pointer is visible by default.

		**Note:** You need to call `Mouse.hide()` only once,
		regardless of the number of previous calls to
		`Mouse.show()`.

	**/
	public static hide(): void
	{
		Mouse.__hidden = true;

		// TODO
		// for (window in Application.current.windows)
		// {
		// 	window.cursor = null;
		// }
	}

	/**
		Registers a native cursor under the given name, with the given data.

		@param name   The name to use as a reference to the native cursor
					  instance.
		@param cursor The properties for the native cursor, such as icon
					  bitmap, specified as a MouseCursorData instance.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10_2) public static registerCursor (name:String, cursor:openfl.ui.MouseCursorData):Void;

	/**
		Displays the pointer. The pointer is visible by default.

		**Note:** You need to call `Mouse.show()` only once,
		regardless of the number of previous calls to
		`Mouse.hide()`.

	**/
	public static show(): void
	{
		Mouse.__hidden = false;
		var cacheCursor = Mouse.__cursor;
		Mouse.__cursor = null;
		Mouse.__setCursor(cacheCursor);
	}

	protected static __setCursor(value: MouseCursor): void
	{
		// TODO
		// var limeCursor: LimeMouseCursor = null;

		// switch (value)
		// {
		// 	case MouseCursor.ARROW:
		// 		limeCursor = ARROW;
		// 	case MouseCursor.BUTTON:
		// 		limeCursor = POINTER;
		// 	case MouseCursor.HAND:
		// 		limeCursor = MOVE;
		// 	case MouseCursor.IBEAM:
		// 		limeCursor = TEXT;
		// 	case MouseCursor.__CROSSHAIR:
		// 		limeCursor = CROSSHAIR;
		// 	case MouseCursor.__CUSTOM:
		// 		limeCursor = CUSTOM;
		// 	case MouseCursor.__RESIZE_NESW:
		// 		limeCursor = RESIZE_NESW;
		// 	case MouseCursor.__RESIZE_NS:
		// 		limeCursor = RESIZE_NS;
		// 	case MouseCursor.__RESIZE_NWSE:
		// 		limeCursor = RESIZE_NWSE;
		// 	case MouseCursor.__RESIZE_WE:
		// 		limeCursor = RESIZE_WE;
		// 	case MouseCursor.__WAIT:
		// 		limeCursor = WAIT;
		// 	case MouseCursor.__WAIT_ARROW:
		// 		limeCursor = WAIT_ARROW;
		// 	default:
		// }

		// if (limeCursor != null && !Mouse.__hidden)
		// {
		// 	for (window in Application.current.windows)
		// 	{
		// 		window.cursor = limeCursor;
		// 	}
		// }
	}

	protected static __setStageCursor(stage: Stage, cursor: MouseCursor): void
	{
		// TODO
		// var limeCursor: LimeMouseCursor = null;

		// switch (value)
		// {
		// 	case MouseCursor.ARROW:
		// 		limeCursor = ARROW;
		// 	case MouseCursor.BUTTON:
		// 		limeCursor = POINTER;
		// 	case MouseCursor.HAND:
		// 		limeCursor = MOVE;
		// 	case MouseCursor.IBEAM:
		// 		limeCursor = TEXT;
		// 	case MouseCursor.__CROSSHAIR:
		// 		limeCursor = CROSSHAIR;
		// 	case MouseCursor.__CUSTOM:
		// 		limeCursor = CUSTOM;
		// 	case MouseCursor.__RESIZE_NESW:
		// 		limeCursor = RESIZE_NESW;
		// 	case MouseCursor.__RESIZE_NS:
		// 		limeCursor = RESIZE_NS;
		// 	case MouseCursor.__RESIZE_NWSE:
		// 		limeCursor = RESIZE_NWSE;
		// 	case MouseCursor.__RESIZE_WE:
		// 		limeCursor = RESIZE_WE;
		// 	case MouseCursor.__WAIT:
		// 		limeCursor = WAIT;
		// 	case MouseCursor.__WAIT_ARROW:
		// 		limeCursor = WAIT_ARROW;
		// 	default:
		// }

		// if (limeCursor != null && !Mouse.__hidden)
		// {
		// 	// TODO
		// 	//stage.window.cursor = limeCursor;
		// }
	}

	/**
		Unregisters the native cursor with the given name.

		@param name The name referring to the native cursor instance.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash11) public static unregisterCursor (name:String):Void;

	// Get & Set Methods

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
	public static get cursor(): MouseCursor
	{
		return Mouse.__cursor;
	}

	public static set cursor(value: MouseCursor)
	{
		if (value == null) value = MouseCursor.AUTO;
		Mouse.__setCursor(value);
		Mouse.__cursor = value;
	}
}
