package flash.ui;

#if flash
@:final extern class Mouse
{
	@:require(flash10) public static var cursor:MouseCursor;
	@:require(flash10_1) public static var supportsCursor(default, never):Bool;
	@:require(flash11) public static var supportsNativeCursor(default, never):Bool;
	public static function hide():Void;
	#if flash
	@:require(flash10_2) public static function registerCursor(name:String, cursor:flash.ui.MouseCursorData):Void;
	#end
	public static function show():Void;
	#if flash
	@:require(flash11) public static function unregisterCursor(name:String):Void;
	#end
}
#else
typedef Mouse = openfl.ui.Mouse;
#end
