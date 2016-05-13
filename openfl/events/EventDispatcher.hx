package openfl.events; #if !openfl_legacy


import openfl.events.EventPhase;
import openfl.events.IEventDispatcher;

@:access(openfl.events.Event)


class EventDispatcher implements IEventDispatcher {
	
	
	private var __dispatching:Map<String, Bool>;
	private var __targetDispatcher:IEventDispatcher;
	private var __eventMap:Map<String, Array<Listener>>;
	private var __newEventMap:Map<String, Array<Listener>>;
	
	
	public function new (target:IEventDispatcher = null):Void {
		
		if (target != null) {
			
			__targetDispatcher = target;
			
		}
		
	}
	
	
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		if (__eventMap == null) {
			
			__dispatching = new Map ();
			__eventMap = new Map ();
			__newEventMap = new Map ();
			
		}
		
		if (!__eventMap.exists (type)) {
			
			var list = new Array<Listener> ();
			list.push (new Listener (listener, useCapture, priority));
			__eventMap.set (type, list);
			
		} else {
			
			var list;
			
			if (__dispatching.get (type) == true) {
				
				if (!__newEventMap.exists (type)) {
					
					list = __eventMap.get (type).copy ();
					__newEventMap.set (type, list);
					
				} else {
					
					list = __newEventMap.get (type);
					
				}
				
			} else {
				
				list = __eventMap.get (type);
				
			}
			
			for (i in 0...list.length) {
				
				if (Reflect.compareMethods (list[i].callback, listener)) return;
				
			}
			
			list.push (new Listener (listener, useCapture, priority));
			list.sort (__sortByPriority);
			
		}
		
	}
	
	
	public function dispatchEvent (event:Event):Bool {
		
		if (__targetDispatcher != null) {
			
			event.target = __targetDispatcher;
			
		} else {
			
			event.target = this;
			
		}
		
		return __dispatchEvent (event);
		
	}
	
	
	public function hasEventListener (type:String):Bool {
		
		if (__eventMap == null) return false;
		
		if (__dispatching.get (type) == true && __newEventMap.exists (type)) {
			
			return __newEventMap.get (type).length > 0;
			
		} else {
			
			return __eventMap.exists (type);
			
		}
		
	}
	
	
	public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		
		if (__eventMap == null) return;
		
		var list = __eventMap.get (type);
		if (list == null) return;
		
		var dispatching = (__dispatching.get (type) == true);
		
		if (dispatching) {
			
			if (!__newEventMap.exists (type)) {
				
				list = __eventMap.get (type).copy ();
				__newEventMap.set (type, list);
				
			} else {
				
				list = __newEventMap.get (type);
				
			}
			
		}
		
		for (i in 0...list.length) {
			
			if (list[i].match (listener, useCapture)) {
				
				list.splice (i, 1);
				break;
				
			}
			
		}
		
		if (!dispatching) {
			
			if (list.length == 0) {
				
				__eventMap.remove (type);
				
			}
			
			if (!__eventMap.iterator ().hasNext ()) {
				
				__eventMap = null;
				__newEventMap = null;
				
			}
			
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
	
	
	private function __dispatchEvent (event:Event):Bool {
		
		if (__eventMap == null || event == null) return false;
		
		var type = event.type;
		var list;
		
		if (__dispatching.get (type) == true) {
			
			list = __newEventMap.get (type);
			if (list == null) return false;
			list = list.copy ();
			
		} else {
			
			list = __eventMap.get (type);
			if (list == null) return false;
			__dispatching.set (type, true);
			
		}
		
		if (event.target == null) {
			
			if (__targetDispatcher != null) {
				
				event.target = __targetDispatcher;
				
			} else {
				
				event.target = this;
				
			}
			
		}
		
		event.currentTarget = this;
		
		var capture = (event.eventPhase == EventPhase.CAPTURING_PHASE);
		var index = 0;
		var listener;
		
		while (index < list.length) {
			
			listener = list[index];
			
			if (listener.useCapture == capture) {
				
				//listener.callback (event.clone ());
				listener.callback (event);
				
				if (event.__isCanceledNow) {
					
					break;
					
				}
				
			}
			
			if (listener == list[index]) {
				
				index++;
				
			}
			
		}
		
		if (__newEventMap != null && __newEventMap.exists (type)) {
			
			var list = __newEventMap.get (type);
			
			if (list.length > 0) {
				
				__eventMap.set (type, list);
				
			} else {
				
				__eventMap.remove (type);
				
			}
			
			if (!__eventMap.iterator ().hasNext ()) {
				
				__eventMap = null;
				__newEventMap = null;
				
			} else {
				
				__newEventMap.remove (type);
				
			}
			
		}
		
		__dispatching.set (event.type, false);
		
		return true;
		
	}
	
	
	private static function __sortByPriority (l1:Listener, l2:Listener):Int {
		
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


#else
typedef EventDispatcher = openfl._legacy.events.EventDispatcher;
#end