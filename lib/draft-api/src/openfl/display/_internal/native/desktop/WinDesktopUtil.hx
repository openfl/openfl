package openfl.display._internal.native.desktop;

import openfl.display._internal.native.desktop.extension.WinDesktopUtilExtern;

/**
 * ...
 * @author Christopher Speciale
 */
@:access(openfl.display._internal.native.desktop.extension.WinDesktopUtilExtern)
class WinDesktopUtil
{
	public static function getCursorPos():Array<Int>
	{
		return WinDesktopUtilExtern.__getCursorPos();
	}
}
