package openfl.display;

import _internal.native.menu.ContextMenuData.ContextMenuItemData;
import openfl.events.Event;
import openfl.events.EventType;
import openfl.utils.Object;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author Christopher Speciale
 */
@:access(openfl.display.NativeMenu)
class NativeMenuItem extends EventDispatcher
{
	public var checked(get, set):Bool;
	public var data:Object;
	public var enabled(get, set):Bool;
	public var isSeparator(get, set):Bool;
	public var keyEquivalent(get, set):Null<String>;
	public var keyEquivalentModifiers(get, set):Array<Int>;
	public var label(get, set):String;
	public var menu(get, never):NativeMenu;
	public var mnemonicIndex(get, set):Int;
	public var name:String;
	public var submenu(get, set):NativeMenu;

	private var __contextMenuItemData:ContextMenuItemData;
	private var __menu:NativeMenu;
	private var __submenu:NativeMenu;

	private function __setMenu(menu:NativeMenu):Void
	{
		__menu = menu;

		if (__submenu != null)
		{
			__submenu.__parent = __menu;
		}
	}

	public function new(label:String = "", isSeparator:Bool = false)
	{
		super();

		__contextMenuItemData = new ContextMenuItemData(label, isSeparator);
		name = "";
	}

	public function clone():NativeMenuItem
	{
		// TODO: clone has to recursively clone children, these hold references.
		var item:NativeMenuItem = Type.createEmptyInstance(NativeMenuItem);
		item.__contextMenuItemData = __contextMenuItemData.clone();
		item.data = data;
		item.__menu = __menu;
		item.name = name;
		item.__submenu = __submenu;
		return item;
	}

	private function get_checked():Bool
	{
		return __contextMenuItemData.checked;
	}

	private function set_checked(value:Bool):Bool
	{
		__contextMenuItemData.checked = value;

		return value;
	}

	private function get_enabled():Bool
	{
		return __contextMenuItemData.enabled;
	}

	private function set_enabled(value:Bool)
	{
		__contextMenuItemData.enabled = value;
		__menu.__update();

		return value;
	}

	private function get_isSeparator():Bool
	{
		return __contextMenuItemData.isSeparator;
	}

	private function set_isSeparator(value:Bool)
	{
		__contextMenuItemData.isSeparator = value;
		__menu.__update();

		return value;
	}

	private function get_keyEquivalent():String
	{
		return __contextMenuItemData.keyEquivalent;
	}

	private function set_keyEquivalent(value:String):String
	{
		__contextMenuItemData.keyEquivalent = value;
		__menu.__update();

		return value;
	}

	private function get_keyEquivalentModifiers():Array<Int>
	{
		return __contextMenuItemData.keyEquivalentModifiers;
	}

	private function set_keyEquivalentModifiers(value:Array<Int>):Array<Int>
	{
		__contextMenuItemData.keyEquivalentModifiers = value;
		__menu.__update();

		return value;
	}

	private function get_label():String
	{
		return __contextMenuItemData.label;
	}

	private function set_label(value:String):String
	{
		__contextMenuItemData.label = value;
		__menu.__update();

		return value;
	}

	private function get_menu():NativeMenu
	{
		return __menu;
	}

	private function get_mnemonicIndex():Int
	{
		return __contextMenuItemData.mnemonicIndex;
	}

	private function set_mnemonicIndex(value:Int):Int
	{
		__contextMenuItemData.mnemonicIndex = value;
		__menu.__update();

		return value;
	}

	private function get_submenu():NativeMenu
	{
		return __submenu;
	}

	private function set_submenu(value:NativeMenu):NativeMenu
	{
		__submenu = value;
		if (__menu != null)
		{
			__submenu.__parent = __menu;
		}

		__contextMenuItemData.submenu = __submenu.__contextMenuData;
		__submenu.__update();

		return value;
	}

	private function __dispatchSelectEvent():Void
	{
		dispatchEvent(new Event(Event.SELECT));
	}

	override public function addEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false, priority:Int = 0,
			useWeakReference:Bool = false):Void
	{
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);

		var menuId:UInt = Reflect.field(__contextMenuItemData, "_id");
		NativeMenu.__callbacks.set(menuId, __dispatchSelectEvent);
	}

	override public function removeEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false):Void
	{
		super.removeEventListener(type, listener, useCapture);

		var menuId:UInt = Reflect.field(__contextMenuItemData, "_id");
		NativeMenu.__callbacks.remove(menuId);
	}
}
