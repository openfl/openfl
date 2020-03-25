/**
	The MouseCursor class is an enumeration of constant values used in setting
	the `cursor` property of the Mouse class.
**/
export enum MouseCursor
{
	/**
		Used to specify that the arrow cursor should be used.
	**/
	ARROW = "arrow",

	/**
		Used to specify that the cursor should be selected automatically based
		on the object under the mouse.
	**/
	AUTO = "auto",

	/**
		Used to specify that the button pressing hand cursor should be used.
	**/
	BUTTON = "button",

	/**
		Used to specify that the dragging hand cursor should be used.
	**/
	HAND = "hand",

	/**
		Used to specify that the I-beam cursor should be used.
	**/
	IBEAM = "ibeam",

	// protected __CROSSHAIR = "crosshair";
	// protected __CUSTOM = "custom";
	// protected __MOVE = "move";
	// protected __RESIZE_NESW = "resize_nesw";
	// protected __RESIZE_NS = "resize_ns";
	// protected __RESIZE_NWSE = "resize_nwse";
	// protected __RESIZE_WE = "resize_we";
	// protected __WAIT = "wait";
	// protected __WAIT_ARROW = "waitarrow";
}

export default MouseCursor;
