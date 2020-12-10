package flash.events;

#if flash
import openfl.display.InteractiveObject;
import openfl.events.EventType;

extern class ContextMenuEvent extends Event
{
	public static var MENU_ITEM_SELECT(default, never):EventType<ContextMenuEvent>;
	public static var MENU_SELECT(default, never):EventType<ContextMenuEvent>;
	public var contextMenuOwner:InteractiveObject;
	#if flash
	@:require(flash10) public var isMouseTargetInaccessible:Bool;
	#end
	public var mouseTarget:InteractiveObject;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, mouseTarget:InteractiveObject = null,
		contextMenuOwner:InteractiveObject = null);
	public override function clone():ContextMenuEvent;
}
#else
typedef ContextMenuEvent = openfl.events.ContextMenuEvent;
#end
