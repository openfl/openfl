package flash.ui;

#if flash
@:final extern class Mouse
{
	#if (haxe_ver < 4.3)
	@:require(flash10) public static var cursor:MouseCursor;
	@:require(flash10_1) public static var supportsCursor(default, never):Bool;
	@:require(flash10_2) public static var supportsNativeCursor(default, never):Bool;
	#else
	@:flash.property @:require(flash10) static var cursor(get, set):MouseCursor;
	@:flash.property @:require(flash10_1) static var supportsCursor(get, never):Bool;
	@:flash.property @:require(flash10_2) static var supportsNativeCursor(get, never):Bool;
	#end

	public static function hide():Void;
	@:require(flash10_2) public static function registerCursor(name:String, cursor:flash.ui.MouseCursorData):Void;
	public static function show():Void;
	@:require(flash10_2) public static function unregisterCursor(name:String):Void;

	#if (haxe_ver >= 4.3)
	private static function get_cursor():MouseCursor;
	private static function get_supportsCursor():Bool;
	private static function get_supportsNativeCursor():Bool;
	private static function set_cursor(value:MouseCursor):MouseCursor;
	#end
}
#else
typedef Mouse = openfl.ui.Mouse;
#end
