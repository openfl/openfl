package openfl.events; #if !openfl_legacy


import haxe.macro.Expr;
import openfl.display.InteractiveObject;


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
	
	public var bubbles (default, null):Bool;
	public var cancelable (default, null):Bool;
	public var currentTarget (default, null):Dynamic;
	public var eventPhase (default, null):EventPhase;
	public var target (default, null):Dynamic;
	public var type (default, null):String;
	
	private var __isCancelled:Bool;
	private var __isCancelledNow:Bool;
	private var __preventDefault:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false) {
		
		this.type = type;
		this.bubbles = bubbles;
		this.cancelable = cancelable;
		eventPhase = EventPhase.AT_TARGET;
		
	}
	
	
	public function clone ():Event {
		
		var event = new Event (type, bubbles, cancelable);
		event.eventPhase = eventPhase;
		event.target = target;
		event.currentTarget = currentTarget;
		return event;
		
	}
	
	
	public function formatToString (className:String, ?p1:String, ?p2:String, ?p3:String, ?p4:String, ?p5:String):String {
		
		var parameters = [];
		if (p1 != null) parameters.push (p1);
		if (p2 != null) parameters.push (p2);
		if (p3 != null) parameters.push (p3);
		if (p4 != null) parameters.push (p4);
		if (p5 != null) parameters.push (p5);
		
		return Reflect.callMethod (this, __formatToString, [ className, parameters ]);
		
	}
	
	
	public function isDefaultPrevented ():Bool {
		
		return __preventDefault;
		
	}
	
	
	public function preventDefault ():Void {
		
		if (cancelable) {
			
			__preventDefault = true;
			
		}
		
	}
	
	
	public function stopImmediatePropagation ():Void {
		
		__isCancelled = true;
		__isCancelledNow = true;
		
	}
	
	
	public function stopPropagation ():Void {
		
		__isCancelled = true;
		
	}
	
	
	public function toString ():String {
		
		return __formatToString ("Event",  [ "type", "bubbles", "cancelable" ]);
		
	}
	
	
	private function __formatToString (className:String, parameters:Array<String>):String {
		
		// TODO: Make this a macro function, and handle at compile-time, with rest parameters?
		
		var output = '[$className';
		var arg:Dynamic = null;
		
		for (param in parameters) {
			
			arg = Reflect.field (this, param);
			
			if (Std.is (arg, String)) {
				
				output += ' $param="$arg"';
				
			} else {
				
				output += ' $param=$arg';
				
			}
			
		}
		
		output += "]";
		return output;
		
	}
	
	
}


#else
typedef Event = openfl._legacy.events.Event;
#end