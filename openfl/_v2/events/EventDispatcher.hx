package openfl._v2.events; #if (!flash && !html5 && !openfl_next)


import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.IOErrorEvent;
import openfl._v2.events.IEventDispatcher;
import openfl._v2.utils.WeakRef;

@:access(openfl._v2.events.Event)


class EventDispatcher implements IEventDispatcher {
	
	
	@:noCompletion private var __targetDispatcher:IEventDispatcher;
	@:noCompletion private var __eventMap:Map<String, Array<Listener>>;
	
	@:noCompletion private var __loopingType:String;
	@:noCompletion private var __loopingCapture:Bool;
	@:noCompletion private var __loopIndex:UInt;
	
	public function new (target:IEventDispatcher = null):Void {
		
		if (target != null) {
			
			__targetDispatcher = target;
			
		}
		
	}
	
	
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		if (__eventMap == null) {
			
			__eventMap = new Map<String, Array<Listener>> ();
			
		}
		
		if (!__eventMap.exists (type)) {
			
			var list = new Array<Listener> ();
			list.push (new Listener (listener, useCapture, priority));
			__eventMap.set (type, list);
			
		} else {
			
			var list = __eventMap.get (type);
			
			for (i in 0...list.length) {
				
				if (Reflect.compareMethods (list[i].callback, listener)) return;
				
			}
			
			var insertIndex = 0;
			
			while (insertIndex < list.length) {
				
				if (list[insertIndex].priority < priority) {
					
					break;
					
				} else {
					
					insertIndex++;
					
				}
				
			}
			
			list.insert (insertIndex, new Listener (listener, useCapture, priority));
			
			if (__loopingType == type && __loopingCapture == useCapture && __loopIndex >= insertIndex) {
				
				__loopIndex++;
				
			}
		}
		
	}
	
	
	public function dispatchEvent (event:Event):Bool {
		
		if (__eventMap == null || event == null) return false;
		
		var list = __eventMap.get (event.type);
		
		if (list == null) return false;
		
		if (event.target == null) {
			
			if (__targetDispatcher != null) {
				
				event.target = __targetDispatcher;
				
			} else {
				
				event.target = this;
				
			}
			
		}
		
		event.currentTarget = this;
		
		var capture = (event.eventPhase == EventPhase.CAPTURING_PHASE);
		__loopIndex = 0;
		__loopingType = event.type;
		__loopingCapture = capture;
		var listener;
		
		while (__loopIndex < list.length) {
			
			listener = list[__loopIndex];
			
			if (listener.useCapture == capture) {
				
				//listener.callback (event.clone ());
				listener.callback (event);
				
				if (event.__isCancelledNow) {
					__loopingType = null;
					return true;
					
				}
				
			}
			
			__loopIndex++;
			
		}
		
		__loopingType = null;
		
		return true;
		
	}
	
	
	public function hasEventListener (type:String):Bool {
		
		if (__eventMap == null) return false;
		return __eventMap.exists (type);
		
	}
	
	
	public function removeEventListener (type:String, listener:Dynamic->Void, capture:Bool = false):Void {
		
		if (__eventMap == null) return;
		
		var list = __eventMap.get (type);
		
		if (list == null) return;
		
		for (i in 0...list.length) {
			
			if (list[i].match (listener, capture)) {
				
				list.splice (i, 1);
				
				if (__loopingType == type && __loopingCapture == capture && __loopIndex >= i) {
					
					__loopIndex--;
					
				}
				
				break;
				
			}
			
		}
		
		if (list.length == 0) {
			
			__eventMap.remove (type);
			
		}
		
		if (!__eventMap.iterator ().hasNext ()) {
			
			__eventMap = null;
			
		}
		
	}
	
	
	public function toString ():String { 
		
		var full = Type.getClassName (Type.getClass (this));
		var short = full.split (".").pop ();
		
		return untyped "[object " + short + "]";
		
	}
	
	
	public function willTrigger (type:String):Bool {
		
		return hasEventListener (type);
		
	}
	
	
	@:noCompletion public function __dispatchCompleteEvent ():Void {
		
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	@:noCompletion public function __dispatchIOErrorEvent ():Void {
		
		dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
		
	}
	
	
	@:noCompletion private static function __sortByPriority (l1:Listener, l2:Listener):Int {
		
		return l1.priority == l2.priority ? 0 : (l1.priority > l2.priority ? -1 : 1);
		
	}
	
	
}


private class Listener {
	
	
	public var callback:Dynamic->Void;
	public var priority:Int;
	public var useCapture:Bool;
	
	
	public function new (callback:Dynamic->Void, useCapture:Bool, priority:Int) {
		
		this.callback = callback;
		this.useCapture = useCapture;
		this.priority = priority;
		
	}
	
	
	public function match (callback:Dynamic->Void, useCapture:Bool) {
		
		return (Reflect.compareMethods (this.callback, callback) && this.useCapture == useCapture);
		
	}
	
	
}


#end