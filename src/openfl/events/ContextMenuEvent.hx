package openfl.events;


import openfl.display.InteractiveObject;


class ContextMenuEvent extends Event {
	
	
	public static inline var MENU_ITEM_SELECT = "menuItemSelect";
	public static inline var MENU_SELECT = "menuSelect";
	
	public var contextMenuOwner:InteractiveObject;
	public var mouseTarget:InteractiveObject;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, mouseTarget:InteractiveObject = null, contextMenuOwner:InteractiveObject = null) {
		
		super (type, bubbles, cancelable);
		
		this.mouseTarget = mouseTarget;
		this.contextMenuOwner = contextMenuOwner;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new ContextMenuEvent (type, bubbles, cancelable, mouseTarget, contextMenuOwner);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("ContextMenuEvent",  [ "type", "bubbles", "cancelable", "mouseTarget", "contextMenuOwner" ]);
		
	}
	
	
}