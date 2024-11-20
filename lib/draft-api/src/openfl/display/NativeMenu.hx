package openfl.display;

import _internal.native.menu.ContextMenuData;
import _internal.native.menu.WinMenuUtil;
import openfl.desktop.NativeApplication;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventType;
import openfl.events.IEventDispatcher;
import haxe.Constraints.Function;
import haxe.ds.IntMap;

/**
 * ...
 * @author Christopher Speciale
 */
@:access(openfl.display.NativeMenuItem)
class NativeMenu extends EventDispatcher
{
	private static var __hasContextMenuListener:Bool = false;

	public static var isSupported(get, never):Bool;

	private static inline function get_isSupported():Bool
	{
		#if windows
		return true;
		#else
		return false;
		#end
	}

	public var items(get, set):Array<NativeMenuItem>;
	public var numItems(get, never):Int;
	public var parent(get, never):NativeMenu;

	public var name:String = "";

	private var __items:Array<NativeMenuItem>;
	private var __parent:NativeMenu;
	private var __contextMenuData:ContextMenuData;

	public function new()
	{
		super();
		__items = [];
		__contextMenuData = new ContextMenuData();
	}

	private function get_parent():NativeMenu
	{
		return __parent;
	}

	public inline function addItem(item:NativeMenuItem):NativeMenuItem
	{
		item.__setMenu(this);
		__items.push(item);
		__contextMenuData.items.push(item.__contextMenuItemData);

		__update();

		return item;
	}

	public function addItemAt(item:NativeMenuItem, index:Int):NativeMenuItem
	{
		item.__setMenu(this);
		__items.insert(index, item);
		__contextMenuData.items.insert(index, item.__contextMenuItemData);

		__update();

		return item;
	}

	public function addSubmenu(submenu:NativeMenu, label:String):NativeMenuItem
	{
		var item:NativeMenuItem = new NativeMenuItem(label);
		item.submenu = submenu;

		item.__setMenu(this);
		__items.push(item);

		__update();

		return item;
	}

	public function addSubMenuAt(submenu:NativeMenu, index:Int, label:String):NativeMenuItem
	{
		var item:NativeMenuItem = new NativeMenuItem(label);
		item.submenu = submenu;
		item.__setMenu(this);

		__items.insert(index, item);

		__update();

		return item;
	}

	public function clone():NativeMenu
	{
		var data:NativeMenu = new NativeMenu();

		return data;
	}

	public function containsItem(item:NativeMenuItem):Bool
	{
		return __items.indexOf(item) > -1 ? true : false;
	}

	public function display(stage:Stage, stageX:Float, stageY:Float):Void
	{
		dispatchEvent(new Event(Event.DISPLAYING));
		@:privateAccess
		__setupNativeListener(NativeApplication.nativeApplication.activeWindow.__hWnd);
	}

	public function getItemAt(index:Int):NativeMenuItem
	{
		return __items[index];
	}

	public function getItemByName(name:String):NativeMenuItem
	{
		for (item in __items)
		{
			if (item.name == name)
			{
				return item;
			}
		}

		return null;
	}

	public function getItemIndex(item:NativeMenuItem):Int
	{
		return __items.indexOf(item);
	}

	public function removeAllItems():Void
	{
		__contextMenuData.removeAllItems();

		__update();
	}

	public function removeItem(item:NativeMenuItem):NativeMenuItem
	{
		item.__setMenu(null);
		__contextMenuData.removeItem(item.__contextMenuItemData);

		__update();

		return item;
	}

	public function removeItemAt(index:Int):NativeMenuItem
	{
		var item:NativeMenuItem = __items.splice(index, 1)[0];
		item.__setMenu(null);

		__contextMenuData.items.splice(index, 1);

		__update();

		return item;
	}

	public function setItemIndex(item:NativeMenuItem, index:Int):Void
	{
		var currentItemIndex:Int = __items.indexOf(item);

		if (currentItemIndex == -1)
		{
			__items.insert(index, item);
		}
		else
		{
			__items.splice(currentItemIndex, 1);
			__items.insert(index, item);
		}

		__update();
	}

	private function get_items():Array<NativeMenuItem>
	{
		return __items.copy();
	}

	private function set_items(value:Array<NativeMenuItem>):Array<NativeMenuItem>
	{
		__items = value;
		__update();

		return value;
	}

	private function get_numItems():Int
	{
		return __items.length;
	}

	private function __update():Void
	{
		if (__parent != null)
		{
			__parent.__update();
		}
		else
		{
			for (window in NativeApplication.nativeApplication.openedWindows)
			{
				if (window.menu == this)
				{
					__redrawNativeWindowMenu(window);
					break;
				}
			}
		}
	}

	private function __redrawNativeWindowMenu(window:NativeWindow):Void
	{
		window.menu = this;
	}

	private function __setupNativeListener(hWnd:Int):Void
	{
		if (!__hasContextMenuListener)
		{
			WinMenuUtil.addContextMenuListener(hWnd, __onMenuItemSelect);

			__hasContextMenuListener = true;
		}
	}

	private static var __callbacks:IntMap<Function> = new IntMap();

	private static function __onMenuItemSelect(id:UInt):Void
	{
		if (__callbacks.exists(id))
		{
			var callback:Function = __callbacks.get(id);
			callback();
		}
	}
}
