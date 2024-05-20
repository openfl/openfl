package _internal.native.desktop;

import _internal.native.desktop.extension.WinDesktopUtilExtern;

/**
 * ...
 * @author Christopher Speciale
 */
@:access(_internal.native.desktop.extension.WinDesktopUtilExtern)
class WinDesktopUtil
{
	public static function getCursorPos():Array<Int>
	{
		return WinDesktopUtilExtern.__getCursorPos();
	}
}
