package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
import openfl.display.InteractiveObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ContextMenuEvent extends Event
{
	public static inline var MENU_ITEM_SELECT:EventType<ContextMenuEvent> = "menuItemSelect";
	public static inline var MENU_SELECT:EventType<ContextMenuEvent> = "menuSelect";

	public var contextMenuOwner:InteractiveObject;

	#if false
	// @:noCompletion @:dox(hide) @:require(flash10) public var isMouseTargetInaccessible:Bool;
	#end

	public var mouseTarget:InteractiveObject;

	// @:noCompletion private static var __pool:ObjectPool<ContextMenuEvent> = new ObjectPool<ContextMenuEvent>(function() return new ContextMenuEvent(null),
	// function(event) event.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, mouseTarget:InteractiveObject = null,
			contextMenuOwner:InteractiveObject = null)
	{
		super(type, bubbles, cancelable);

		this.mouseTarget = mouseTarget;
		this.contextMenuOwner = contextMenuOwner;
	}

	public override function clone():ContextMenuEvent
	{
		var event = new ContextMenuEvent(type, bubbles, cancelable, mouseTarget, contextMenuOwner);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("ContextMenuEvent", ["type", "bubbles", "cancelable", "mouseTarget", "contextMenuOwner"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		mouseTarget = null;
		contextMenuOwner = null;
	}
}
#else
typedef ContextMenuEvent = flash.events.ContextMenuEvent;
#end
