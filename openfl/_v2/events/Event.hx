package openfl._v2.events; #if lime_legacy


import openfl.events.EventPhase;

@:allow(openfl._v2.display.DisplayObjectContainer)


class Event {
	
	
	public static var ACTIVATE = "activate";
	public static var ADDED = "added";
	public static var ADDED_TO_STAGE = "addedToStage";
	public static var CANCEL = "cancel";
	public static var CHANGE = "change";
	public static var CLOSE = "close";
	public static var COMPLETE = "complete";
	public static var CONNECT = "connect";
	public static var CONTEXT3D_CREATE = "context3DCreate";
	public static var DEACTIVATE = "deactivate";
	public static var ENTER_FRAME = "enterFrame";
	public static var ID3 = "id3";
	public static var INIT = "init";
	public static var MOUSE_LEAVE = "mouseLeave";
	public static var OPEN = "open";
	public static var REMOVED = "removed";
	public static var REMOVED_FROM_STAGE = "removedFromStage";
	public static var RENDER = "render";
	public static var RESIZE = "resize";
	public static var SCROLL = "scroll";
	public static var SELECT = "select";
	public static var SOUND_COMPLETE = "soundComplete";
	public static var TAB_CHILDREN_CHANGE = "tabChildrenChange";
	public static var TAB_ENABLED_CHANGE = "tabEnabledChange";
	public static var TAB_INDEX_CHANGE = "tabIndexChange";
	public static var UNLOAD = "unload";
	
	public var bubbles (get, never):Bool;
	public var cancelable (get, never):Bool;
	public var currentTarget (get, set):Dynamic;
	public var eventPhase (get, never):EventPhase;
	public var target (get, set):Dynamic;
	public var type (get, never):String;

	@:noCompletion private var __bubbles:Bool;
	@:noCompletion private var __cancelable:Bool;
	@:noCompletion private var __currentTarget:Dynamic;
	@:noCompletion private var __eventPhase:EventPhase;
	@:noCompletion private var __isCancelled:Bool;
	@:noCompletion private var __isCancelledNow:Bool;
	@:noCompletion private var __target:Dynamic;
	@:noCompletion private var __type:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false) {
		
		__type = type;
		__bubbles = bubbles;
		__cancelable = cancelable;
		__isCancelled = false;
		__isCancelledNow = false;
		__target = null;
		__currentTarget = null;
		__eventPhase = EventPhase.AT_TARGET;
		
	}
	
	
	public function clone ():Event {
		
		return new Event (type, bubbles, cancelable);
		
	}
	
	
	public function isDefaultPrevented ():Bool {
		
		return (__isCancelled || __isCancelledNow);
		
	}
	
	
	public function stopImmediatePropagation ():Void {
		
		if (cancelable) {
			
			__isCancelled = true;
			__isCancelledNow = true;
			
		}
		
	}
	
	
	public function stopPropagation ():Void {
		
		if (cancelable) {
			
			__isCancelled = true;
			
		}
		
	}
	
	
	public function toString ():String {
		
		return "[Event type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + "]";
		
	}
	
	
	@:noCompletion public function __getIsCancelled ():Bool {
		
		return __isCancelled;
		
	}
	
	
	@:noCompletion public function __getIsCancelledNow ():Bool {
		
		return __isCancelledNow;
		
	}
	
	
	@:noCompletion public function __setPhase (value:EventPhase):Void {
		
		__eventPhase = value;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_bubbles ():Bool { return __bubbles; }
	private function get_cancelable ():Bool { return __cancelable; }
	private function get_currentTarget ():Dynamic { return __currentTarget; }
	private function set_currentTarget (value:Dynamic):Dynamic { return __currentTarget = value; }
	private function get_eventPhase ():EventPhase { return __eventPhase; }
	private function get_target ():Dynamic { return __target; }
	private function set_target (value:Dynamic):Dynamic { return __target = value; }
	private function get_type ():String { return __type; }
	
	
}


#end