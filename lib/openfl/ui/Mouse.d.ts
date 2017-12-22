import MouseCursor from "./MouseCursor";


declare namespace openfl.ui {
	
	
	/**
	 * The methods of the Mouse class are used to hide and show the mouse pointer,
	 * or to set the pointer to a specific style. The Mouse class is a top-level
	 * class whose properties and methods you can access without using a
	 * constructor. <ph outputclass="flashonly">The pointer is visible by default,
	 * but you can hide it and implement a custom pointer.
	 */
	/*@:final*/ export class Mouse {
		
		
		public static cursor:MouseCursor;
		public static readonly supportsCursor:boolean;
		public static readonly supportsNativeCursor:boolean;
		
		
		/**
		 * Hides the pointer. The pointer is visible by default.
		 *
		 * **Note:** You need to call `Mouse.hide()` only once,
		 * regardless of the number of previous calls to
		 * `Mouse.show()`.
		 * 
		 */
		public static hide ():void;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_2) public static registerCursor (name:string, cursor:flash.ui.MouseCursorData):Void;
		// #end
		
		
		/**
		 * Displays the pointer. The pointer is visible by default.
		 *
		 * **Note:** You need to call `Mouse.show()` only once,
		 * regardless of the number of previous calls to
		 * `Mouse.hide()`.
		 * 
		 */
		public static show ():void;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public static unregisterCursor (name:string):Void;
		// #end
		
		
	}
	
	
}


export default openfl.ui.Mouse;