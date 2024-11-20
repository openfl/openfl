package _internal.native.menu.extension;

import _internal.native.menu.ContextMenuData;
import haxe.Constraints.Function;

/**
 * ...
 * @author Christopher Speciale
 */
@:include('./WinMenuUtilExtern.cpp')
extern class WinMenuUtilExtern
{
	@:native('menuUtil_showPopupMenu') private static function __showPopupMenu(id:Int, menuData:ContextMenuData, x:Int, y:Int):Bool;
	@:native('menuUtil_showPopupMenuAtCursorPos') private static function __showPopupMenuAtCursorPos(id:Int, menuData:ContextMenuData):Bool;
	@:native('menuUtil_addSystemMenu') private static function __addSystemMenu(id:Int, menuData:ContextMenuData):Bool;
	@:native('menuUtil_addContextMenuListener') private static function __addContextMenuListener(id:Int, callback:Function):Bool;
}
