package _internal.native.desktop.extension;

/**
 * ...
 * @author Christopher Speciale
 */
@:include('./WinDesktopUtilExtern.cpp')
extern class WinDesktopUtilExtern
{
	@:native('desktopUtil_getCursorPos') private static function __getCursorPos():Array<Int>;
}
