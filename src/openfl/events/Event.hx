package openfl.events;


import openfl.display.InteractiveObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Event {
	
	
	public static inline var ACTIVATE = "activate";
	public static inline var ADDED = "added";
	public static inline var ADDED_TO_STAGE = "addedToStage";
	public static inline var CANCEL = "cancel";
	public static inline var CHANGE = "change";
	public static inline var CLEAR = "clear";
	public static inline var CLOSE = "close";
	public static inline var COMPLETE = "complete";
	public static inline var CONNECT = "connect";
	public static inline var CONTEXT3D_CREATE = "context3DCreate";
	public static inline var COPY = "copy";
	public static inline var CUT = "cut";
	public static inline var DEACTIVATE = "deactivate";
	public static inline var ENTER_FRAME = "enterFrame";
	public static inline var EXIT_FRAME = "exitFrame";
	public static inline var FRAME_CONSTRUCTED = "frameConstructed";
	public static inline var FRAME_LABEL = "frameLabel";
	public static inline var FULLSCREEN = "fullScreen";
	public static inline var ID3 = "id3";
	public static inline var INIT = "init";
	public static inline var MOUSE_LEAVE = "mouseLeave";
	public static inline var OPEN = "open";
	public static inline var PASTE = "paste";
	public static inline var REMOVED = "removed";
	public static inline var REMOVED_FROM_STAGE = "removedFromStage";
	public static inline var RENDER = "render";
	public static inline var RESIZE = "resize";
	public static inline var SCROLL = "scroll";
	public static inline var SELECT = "select";
	public static inline var SELECT_ALL = "selectAll";
	public static inline var SOUND_COMPLETE = "soundComplete";
	public static inline var TAB_CHILDREN_CHANGE = "tabChildrenChange";
	public static inline var TAB_ENABLED_CHANGE = "tabEnabledChange";
	public static inline var TAB_INDEX_CHANGE = "tabIndexChange";
	public static inline var TEXTURE_READY = "textureReady";
	public static inline var UNLOAD = "unload";
	
	public var bubbles (default, null):Bool;
	public var cancelable (default, null):Bool;
	public var currentTarget (default, null):#if (haxe_ver >= "3.4.2") Any #else IEventDispatcher #end;
	public var eventPhase (default, null):EventPhase;
	public var target (default, null):#if (haxe_ver >= "3.4.2") Any #else IEventDispatcher #end;
	public var type (default, null):String;
	
	private var __isCanceled:Bool;
	private var __isCanceledNow:Bool;
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
		
		__isCanceled = true;
		__isCanceledNow = true;
		
	}
	
	
	public function stopPropagation ():Void {
		
		__isCanceled = true;
		
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