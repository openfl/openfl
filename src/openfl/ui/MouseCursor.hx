package openfl.ui;


import lime.ui.MouseCursor in LimeMouseCursor;


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
	
	@:from private static function fromLimeCursor (cursor:LimeMouseCursor):MouseCursor {
		
		return switch (cursor) {
			
			case LimeMouseCursor.ARROW: MouseCursor.ARROW;
			case LimeMouseCursor.DEFAULT: MouseCursor.AUTO;
			case LimeMouseCursor.POINTER: MouseCursor.BUTTON;
			case LimeMouseCursor.MOVE: MouseCursor.HAND;
			case LimeMouseCursor.TEXT: MouseCursor.IBEAM;
			case LimeMouseCursor.CROSSHAIR: MouseCursor.__CROSSHAIR;
			case LimeMouseCursor.RESIZE_NESW: MouseCursor.__RESIZE_NESW;
			case LimeMouseCursor.RESIZE_NS: MouseCursor.__RESIZE_NS;
			case LimeMouseCursor.RESIZE_NWSE: MouseCursor.__RESIZE_NWSE;
			case LimeMouseCursor.RESIZE_WE: MouseCursor.__RESIZE_WE;
			case LimeMouseCursor.WAIT: MouseCursor.__WAIT;
			case LimeMouseCursor.WAIT_ARROW: MouseCursor.__WAIT_ARROW;
			case LimeMouseCursor.CUSTOM: MouseCursor.__CUSTOM;
			default: MouseCursor.AUTO;
			
		}
		
	}
	
}