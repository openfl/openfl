package openfl.ui;

#if (display || !flash)
@:jsRequire("openfl/ui/Mouse", "default")
/**
 * The methods of the Mouse class are used to hide and show the mouse pointer,
 * or to set the pointer to a specific style. The Mouse class is a top-level
 * class whose properties and methods you can access without using a
 * constructor. <ph outputclass="flashonly">The pointer is visible by default,
 * but you can hide it and implement a custom pointer.
 */
@:final extern class Mouse
{
	public static var cursor:MouseCursor;
	public static var supportsCursor(default, null):Bool;
	public static var supportsNativeCursor(default, null):Bool;

	/**
	 * Hides the pointer. The pointer is visible by default.
	 *
	 * **Note:** You need to call `Mouse.hide()` only once,
	 * regardless of the number of previous calls to
	 * `Mouse.show()`.
	 *
	 */
	public static function hide():Void;

	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_2) public static function registerCursor(name:String, cursor:flash.ui.MouseCursorData):Void;
	#end

	/**
	 * Displays the pointer. The pointer is visible by default.
	 *
	 * **Note:** You need to call `Mouse.show()` only once,
	 * regardless of the number of previous calls to
	 * `Mouse.hide()`.
	 *
	 */
	public static function show():Void;

	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public static function unregisterCursor(name:String):Void;
	#end
}
#else
typedef Mouse = flash.ui.Mouse;
#end
