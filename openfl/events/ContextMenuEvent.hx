package openfl.events; #if !flash


import openfl.display.InteractiveObject;


class ContextMenuEvent extends Event {
	
	
	public static var MENU_ITEM_SELECT:String = "menuItemSelect";
	public static var MENU_SELECT:String = "menuSelect";
	
	public var contextMenuOwner:InteractiveObject;
	public var mouseTarget:InteractiveObject;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, mouseTarget:InteractiveObject = null, contextMenuOwner:InteractiveObject = null) {
		
		super (type, bubbles, cancelable);
		
		this.mouseTarget = mouseTarget;
		this.contextMenuOwner = contextMenuOwner;
		
	}
	
	
}


#else
typedef ContextMenuEvent = flash.events.ContextMenuEvent;
#end