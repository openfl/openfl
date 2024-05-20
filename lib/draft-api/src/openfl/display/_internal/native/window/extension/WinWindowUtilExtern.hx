package _internal.native.window.extension;

import haxe.Constraints.Function;

/**
 * ...
 * @author Christopher Speciale
 */
@:include('./WinWindowUtilExtern.cpp')
extern class WinWindowUtilExtern
{
	@:native('windowUtil_getHWNDByName') private static function __getHWNDByName(value:String):Int;
	@:native('windowUtil_setTransparencyMask') private static function __setTransparencyMask(id:Int, colorMask:Int):Bool;
	@:native('windowUtil_removeTransparencyMask') private static function __removeTransparencyMask(id:Int):Bool;
	@:native('windowUtil_setBlurBehindWindow') private static function __setBlurBehindWindow(id:Int, value:Bool):Bool;
	@:native('windowUtil_setWindowOverlapped') private static function __setWindowOverlapped(id:Int, value:Bool):Bool;
	@:native('windowUtil_createSystemTray') private static function __createSystemTray(id:Int, callback:Function, name:String):Bool;
	@:native('windowUtil_removeSystemTray') private static function __removeSystemTray(id:Int):Bool;
}
