package openfl.events; #if (!display && !flash)


import openfl.display.InteractiveObject;


class ContextMenuEvent extends Event {
	
	
	public static var MENU_ITEM_SELECT = "menuItemSelect";
	public static var MENU_SELECT = "menuSelect";
	
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
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("ContextMenuEvent",  [ "type", "bubbles", "cancelable", "mouseTarget", "contextMenuOwner" ]);
		
	}
	
	
}


#else


#if flash
@:native("flash.events.ContextMenuEvent")
#end

extern class ContextMenuEvent extends Event {
	
	
	public static var MENU_ITEM_SELECT:String;
	public static var MENU_SELECT:String;
	
	public var contextMenuOwner:InteractiveObject;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var isMouseTargetInaccessible:Bool;
	#end
	
	public var mouseTarget:InteractiveObject;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, mouseTarget:InteractiveObject = null, contextMenuOwner:InteractiveObject = null);
	
	
}


#end