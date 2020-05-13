package openfl.ui;

#if lime
import lime.ui.MouseCursor as LimeMouseCursor;
#end

@:noCompletion
@:enum abstract _MouseCursor(MouseCursor) from MouseCursor to MouseCursor from String to String
{
	public var __CROSSHAIR = "crosshair";
	public var __CUSTOM = "custom";
	public var __MOVE = "move";
	public var __RESIZE_NESW = "resize_nesw";
	public var __RESIZE_NS = "resize_ns";
	public var __RESIZE_NWSE = "resize_nwse";
	public var __RESIZE_WE = "resize_we";
	public var __WAIT = "wait";
	public var __WAIT_ARROW = "waitarrow";

	#if lime
	@:from public static function fromLimeCursor(cursor:LimeMouseCursor):_MouseCursor
	{
		return switch (cursor)
		{
			case LimeMouseCursor.ARROW: MouseCursor.ARROW;
			case LimeMouseCursor.DEFAULT: MouseCursor.AUTO;
			case LimeMouseCursor.POINTER: MouseCursor.BUTTON;
			case LimeMouseCursor.MOVE: MouseCursor.HAND;
			case LimeMouseCursor.TEXT: MouseCursor.IBEAM;
			case LimeMouseCursor.CROSSHAIR: _MouseCursor.__CROSSHAIR;
			case LimeMouseCursor.RESIZE_NESW: cast _MouseCursor.__RESIZE_NESW;
			case LimeMouseCursor.RESIZE_NS: cast _MouseCursor.__RESIZE_NS;
			case LimeMouseCursor.RESIZE_NWSE: cast _MouseCursor.__RESIZE_NWSE;
			case LimeMouseCursor.RESIZE_WE: cast _MouseCursor.__RESIZE_WE;
			case LimeMouseCursor.WAIT: cast _MouseCursor.__WAIT;
			case LimeMouseCursor.WAIT_ARROW: cast _MouseCursor.__WAIT_ARROW;
			case LimeMouseCursor.CUSTOM: cast _MouseCursor.__CUSTOM;
			default: MouseCursor.AUTO;
		}
	}

	@:to public function toLimeCursor():LimeMouseCursor
	{
		return switch (this : String)
		{
			case MouseCursor.ARROW: LimeMouseCursor.ARROW;
			case MouseCursor.AUTO: LimeMouseCursor.DEFAULT;
			case MouseCursor.BUTTON: LimeMouseCursor.POINTER;
			case MouseCursor.HAND: LimeMouseCursor.MOVE;
			case MouseCursor.IBEAM: LimeMouseCursor.TEXT;
			case _MouseCursor.__CROSSHAIR: LimeMouseCursor.CROSSHAIR;
			case _MouseCursor.__RESIZE_NESW: LimeMouseCursor.RESIZE_NESW;
			case _MouseCursor.__RESIZE_NS: LimeMouseCursor.RESIZE_NS;
			case _MouseCursor.__RESIZE_NWSE: LimeMouseCursor.RESIZE_NWSE;
			case _MouseCursor.__RESIZE_WE: LimeMouseCursor.RESIZE_WE;
			case _MouseCursor.__WAIT: LimeMouseCursor.WAIT;
			case _MouseCursor.__WAIT_ARROW: LimeMouseCursor.WAIT_ARROW;
			case _MouseCursor.__CUSTOM: LimeMouseCursor.CUSTOM;
			default: LimeMouseCursor.DEFAULT;
		}
	}
	#end
}
