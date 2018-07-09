package openfl.ui;


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
	
	private var __CROSSHAIR = "crosshair";
	private var __CUSTOM = "custom";
	private var __MOVE = "move";
	private var __RESIZE_NESW = "resize_nesw";
	private var __RESIZE_NS = "resize_ns";
	private var __RESIZE_NWSE = "resize_nwse";
	private var __RESIZE_WE = "resize_we";
	private var __WAIT = "wait";
	private var __WAIT_ARROW = "waitarrow";
	
	@:from private static function fromLimeCursor (cursor:Cursor):MouseCursor {
		
		return switch (cursor) {
			
			case Cursor.ARROW: MouseCursor.ARROW;
			case Cursor.DEFAULT: MouseCursor.AUTO;
			case Cursor.POINTER: MouseCursor.BUTTON;
			case Cursor.MOVE: MouseCursor.HAND;
			case Cursor.TEXT: MouseCursor.IBEAM;
			case Cursor.CROSSHAIR: MouseCursor.__CROSSHAIR;
			case Cursor.RESIZE_NESW: MouseCursor.__RESIZE_NESW;
			case Cursor.RESIZE_NS: MouseCursor.__RESIZE_NS;
			case Cursor.RESIZE_NWSE: MouseCursor.__RESIZE_NWSE;
			case Cursor.RESIZE_WE: MouseCursor.__RESIZE_WE;
			case Cursor.WAIT: MouseCursor.__WAIT;
			case Cursor.WAIT_ARROW: MouseCursor.__WAIT_ARROW;
			case Cursor.CUSTOM: MouseCursor.__CUSTOM;
			default: MouseCursor.AUTO;
			
		}
		
	}
	
}