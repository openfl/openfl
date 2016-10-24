package openfl.events;


import openfl.events.EventPhase;
import openfl.events.IEventDispatcher;

@:access(openfl.events.Event)


class EventDispatcher implements IEventDispatcher {
	
	
	private var __eventMap:Map<String, Array<Listener>>;
	private var __iterators:Map<String, DispatchIterator>;
	private var __targetDispatcher:IEventDispatcher;
	
	
	public function new (target:IEventDispatcher = null):Void {
		
		if (target != null) {
			
			__targetDispatcher = target;
			
		}
		
	}
	
	
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		if (__eventMap == null) {
			
			__eventMap = new Map ();
			__iterators = new Map ();
			
		}
		
		if (!__eventMap.exists (type)) {
			
			var list = new Array<Listener> ();
			list.push (new Listener (listener, useCapture, priority));
			
			var iterator = new DispatchIterator (list);
			
			__eventMap.set (type, list);
			__iterators.set (type, iterator);
			
		} else {
			
			var list = __eventMap.get (type);
			
			for (i in 0...list.length) {
				
				if (Reflect.compareMethods (list[i].callback, listener)) return;
				
			}
			
			__iterators.get (type).copy ();
			
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
		
		return __eventMap.exists (type);
		
	}
	
	
	public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		
		if (__eventMap == null) return;
		
		var list = __eventMap.get (type);
		if (list == null) return;
		
		__iterators.get (type).copy ();
		
		for (i in 0...list.length) {
			
			if (list[i].match (listener, useCapture)) {
				
				list.splice (i, 1);
				break;
				
			}
			
		}
		
		if (list.length == 0) {
			
			__eventMap.remove (type);
			__iterators.remove (type);
			
		}
		
		if (!__eventMap.iterator ().hasNext ()) {
			
			__eventMap = null;
			__iterators = null;
			
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
		
		var list = __eventMap.get (type);
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
		var index = 0;
		
		var iterator = __iterators.get (type);
		
		if (iterator.isActive) {
			
			list = list.copy ();
			iterator = new DispatchIterator (list);
			
		}
		
		iterator.reset (list);
		
		for (listener in iterator) {
			
			if (listener.useCapture == capture) {
				
				//listener.callback (event.clone ());
				listener.callback (event);
				
				if (event.__isCanceledNow) {
					
					break;
					
				}
				
			}
			
		}
		
		return true;
		
	}
	
	
	private static function __sortByPriority (l1:Listener, l2:Listener):Int {
		
		return l1.priority == l2.priority ? 0 : (l1.priority > l2.priority ? -1 : 1);
		
	}
	
	
}


@:dox(hide) private class DispatchIterator {
	
	
	public var isActive:Bool;
	
	private var index:Int;
	private var list:Array<Listener>;
	
	
	public function new (list:Array<Listener>) {
		
		this.list = list;
		index = list.length;
		
	}
	
	
	public function copy ():Void {
		
		if (index < list.length) {
			
			list = list.copy ();
			
		}
		
	}
	
	
	public function hasNext ():Bool {
		
		if (index < list.length) {
			
			return true;
			
		} else {
			
			isActive = false;
			return false;
			
		}
		
	}
	
	
	public function next ():Listener {
		
		return list[index++];
		
	}
	
	
	public function reset (list:Array<Listener>):Void {
		
		this.list = list;
		
		index = 0;
		isActive = true;
		
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