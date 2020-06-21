package openfl.ui;

#if (display || !flash)
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

	@:noCompletion private var __CROSSHAIR = "crosshair";
	@:noCompletion private var __CUSTOM = "custom";
	@:noCompletion private var __MOVE = "move";
	@:noCompletion private var __RESIZE_NESW = "resize_nesw";
	@:noCompletion private var __RESIZE_NS = "resize_ns";
	@:noCompletion private var __RESIZE_NWSE = "resize_nwse";
	@:noCompletion private var __RESIZE_WE = "resize_we";
	@:noCompletion private var __WAIT = "wait";
	@:noCompletion private var __WAIT_ARROW = "waitarrow";
	
	// @:from private static function fromLimeCursor (cursor:LimeMouseCursor):MouseCursor {
	// 	return switch (cursor) {
	// 		case LimeMouseCursor.ARROW: MouseCursor.ARROW;
	// 		case LimeMouseCursor.DEFAULT: MouseCursor.AUTO;
	// 		case LimeMouseCursor.POINTER: MouseCursor.BUTTON;
	// 		case LimeMouseCursor.MOVE: MouseCursor.HAND;
	// 		case LimeMouseCursor.TEXT: MouseCursor.IBEAM;
	// 		case LimeMouseCursor.CROSSHAIR: MouseCursor.__CROSSHAIR;
	// 		case LimeMouseCursor.RESIZE_NESW: MouseCursor.__RESIZE_NESW;
	// 		case LimeMouseCursor.RESIZE_NS: MouseCursor.__RESIZE_NWSE;
	// 		case LimeMouseCursor.RESIZE_NWSE: MouseCursor.__RESIZE_NWSE;
	// 		case LimeMouseCursor.RESIZE_WE: MouseCursor.__RESIZE_WE;
	// 		case LimeMouseCursor.WAIT: MouseCursor.__WAIT;
	// 		case LimeMouseCursor.WAIT_ARROW: MouseCursor.__WAIT_ARROW;
	// 		case LimeMouseCursor.CUSTOM: MouseCursor.__CUSTOM;
	// 		default: MouseCursor.AUTO;
	// 	}
	// }
}
#else
typedef MouseCursor = flash.ui.MouseCursor;
#end
