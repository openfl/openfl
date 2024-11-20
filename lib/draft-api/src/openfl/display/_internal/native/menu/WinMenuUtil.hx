package _internal.native.menu;

import _internal.native.menu.extension.WinMenuUtilExtern;
import openfl.Lib;

/**
 * ...
 * @author Christopher Speciale
 */
@:access(_internal.native.menu.extension.WinMenuUtilExtern)
class WinMenuUtil
{
	public static function showPopupMenu(id:Int, menuData:ContextMenuData, x:Int, y:Int):Bool
	{
		return WinMenuUtilExtern.__showPopupMenu(id, menuData, x, y);
	}

	public static function showPopupMenuAtCursorPos(id:Int, menuData:ContextMenuData):Bool
	{
		return WinMenuUtilExtern.__showPopupMenuAtCursorPos(id, menuData);
	}

	public static function addSystemMenu(id:Int, menuData:ContextMenuData):Bool
	{
		return WinMenuUtilExtern.__addSystemMenu(id, menuData);
	}

	public static function addContextMenuListener(id:Int, callback:UInt->Void):Bool
	{
		return WinMenuUtilExtern.__addContextMenuListener(id, callback);
	}
}
