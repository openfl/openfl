package flash.events;

#if flash
import openfl.display.InteractiveObject;
import openfl.events.EventType;

extern class ContextMenuEvent extends Event
{
	public static var MENU_ITEM_SELECT(default, never):EventType<ContextMenuEvent>;
	public static var MENU_SELECT(default, never):EventType<ContextMenuEvent>;

	#if (haxe_ver < 4.3)
	public var contextMenuOwner:InteractiveObject;
	@:require(flash10) public var isMouseTargetInaccessible:Bool;
	public var mouseTarget:InteractiveObject;
	#else
	@:flash.property var contextMenuOwner(get, set):InteractiveObject;
	@:flash.property @:require(flash10) var isMouseTargetInaccessible(get, set):Bool;
	@:flash.property var mouseTarget(get, set):InteractiveObject;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, mouseTarget:InteractiveObject = null,
		contextMenuOwner:InteractiveObject = null);
	public override function clone():ContextMenuEvent;

	#if (haxe_ver >= 4.3)
	private function get_contextMenuOwner():InteractiveObject;
	private function get_isMouseTargetInaccessible():Bool;
	private function get_mouseTarget():InteractiveObject;
	private function set_contextMenuOwner(value:InteractiveObject):InteractiveObject;
	private function set_isMouseTargetInaccessible(value:Bool):Bool;
	private function set_mouseTarget(value:InteractiveObject):InteractiveObject;
	#end
}
#else
typedef ContextMenuEvent = openfl.events.ContextMenuEvent;
#end
