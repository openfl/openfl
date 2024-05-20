package _internal.native.menu;

import openfl.utils.Object;

abstract ContextMenuData(Dynamic)
{
	public var items(get, never):Array<ContextMenuItemData>;

	public inline function new()
	{
		var menu:Dynamic = {};
		menu.items = [];

		this = menu;
	}

	public inline function addItem(item:ContextMenuItemData):ContextMenuItemData
	{
		item.menu = this;
		this.items.push(item);

		return item;
	}

	public inline function atItemAt(item:ContextMenuItemData, index:Int):ContextMenuItemData
	{
		item.menu = this;
		this.items.insert(index, item);

		return item;
	}

	public inline function addSubMenu(submenu:ContextMenuData, label:String):ContextMenuItemData
	{
		var item:ContextMenuItemData = new ContextMenuItemData(label);
		item.menu = this;
		item.submenu = submenu;

		items.push(item);

		return item;
	}

	public inline function clone():ContextMenuData
	{
		var data:ContextMenuData = new ContextMenuData();

		return data;
	}

	public inline function containsItem(item:ContextMenuItemData):Bool
	{
		return this.items.indexOf(item) > -1 ? true : false;
	}

	public inline function getItemAt(index:Int):ContextMenuItemData
	{
		return this.items[index];
	}

	public inline function getItemIndex(item:ContextMenuItemData):Int
	{
		return this.items.indexOf(item);
	}

	public inline function removeAllItems():Void
	{
		for (item in items)
		{
			item.menu = null;
		}

		var menu:Dynamic = {};
		menu.items = [];

		this = menu;
	}

	public inline function removeItem(item:ContextMenuItemData):ContextMenuItemData
	{
		item.menu = null;
		this.items.remove(item);

		return item;
	}

	public inline function removeItemAt(index:Int):ContextMenuItemData
	{
		var item:ContextMenuItemData = this.items.splice(index, 1)[0];
		item.menu = null;
		return item;
	}

	private function get_items():Array<ContextMenuItemData>
	{
		return this.items;
	}
}

abstract ContextMenuItemData(Dynamic)
{
	private static var __idSpace:UInt = 0;

	private static function __getId():UInt
	{
		return __idSpace++;
	}

	public var checked(get, set):Bool;
	public var enabled(get, set):Bool;
	public var isSeparator(get, set):Bool;
	public var keyEquivalent(get, set):Null<String>;
	public var keyEquivalentModifiers(get, set):Array<Int>;
	public var label(get, set):String;
	public var menu(get, set):ContextMenuData;
	public var mnemonicIndex(get, set):Int;
	public var submenu(get, set):ContextMenuData;

	public inline function new(label:String = "", isSeparator:Bool = false)
	{
		var item:Dynamic = {};
		item.checked = false;
		item.enabled = true;
		item.isSeparator = isSeparator;
		item.keyEquivalent = null;
		item.keyEquivalentModifiers = [17];
		item.label = label;
		item.menu = null;
		item.mnemonicIndex = -1;
		item.submenu = null;
		item._id = __getId();

		this = item;
	}

	public function clone():ContextMenuItemData
	{
		var item:ContextMenuItemData = new ContextMenuItemData();
		item.checked = this.checked;
		item.enabled = this.enabled;
		item.isSeparator = this.isSeparator;
		item.keyEquivalent = this.keyEquivalent;
		item.keyEquivalentModifiers = this.keyEquivalentModifiers;
		item.label = this.label;
		item.menu = this.menu;
		item.mnemonicIndex = this.mnemonicIndex;
		item.submenu = this.submenu;

		return item;
	}

	@:noCompletion private function get_checked():Bool
	{
		return this.checked;
	}

	@:noCompletion private function set_checked(value:Bool):Bool
	{
		return this.checked = value;
	}

	@:noCompletion private function get_enabled():Bool
	{
		return this.enabled;
	}

	@:noCompletion private function set_enabled(value:Bool):Bool
	{
		return this.enabled = value;
	}

	@:noCompletion private function get_isSeparator():Bool
	{
		return this.isSeparator;
	}

	@:noCompletion private function set_isSeparator(value:Bool):Bool
	{
		return this.isSeparator = value;
	}

	@:noCompletion private function get_keyEquivalent():String
	{
		return this.keyEquivalent;
	}

	@:noCompletion private function set_keyEquivalent(value:String):String
	{
		return this.keyEquivalent = value;
	}

	@:noCompletion private function get_keyEquivalentModifiers():Array<Int>
	{
		return this.keyEquivalentModifiers;
	}

	@:noCompletion private function set_keyEquivalentModifiers(value:Array<Int>):Array<Int>
	{
		return this.keyEquivalentModifiers = value;
	}

	@:noCompletion private function get_label():String
	{
		return this.label;
	}

	@:noCompletion private function set_label(value:String):String
	{
		return this.label = value;
	}

	@:noCompletion private function get_menu():ContextMenuData
	{
		return this.menu;
	}

	@:noCompletion private function set_menu(value:ContextMenuData):ContextMenuData
	{
		return this.menu = value;
	}

	@:noCompletion private function get_mnemonicIndex():Int
	{
		return this.mnemonicIndex;
	}

	@:noCompletion private function set_mnemonicIndex(value:Int):Int
	{
		return this.mnemonicIndex = value;
	}

	@:noCompletion private function get_name():String
	{
		return this.name;
	}

	@:noCompletion private function set_name(value:String):String
	{
		return this.name = value;
	}

	@:noCompletion private function get_submenu():ContextMenuData
	{
		return this.submenu;
	}

	@:noCompletion private function set_submenu(value:ContextMenuData):ContextMenuData
	{
		return this.submenu = value;
	}
}
