package openfl.events;


import openfl.events.EventPhase;
import openfl.events.IEventDispatcher;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.events.Event)


class EventDispatcher implements IEventDispatcher {
	
	
	private var __eventMap:Map<String, Array<Listener>>;
	private var __iterators:Map<String, Array<DispatchIterator>>;
	private var __targetDispatcher:IEventDispatcher;
	
	
	public function new (target:IEventDispatcher = null):Void {
		
		if (target != null) {
			
			__targetDispatcher = target;
			
		}
		
	}
	
	
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		if (listener == null) return;
		
		if (__eventMap == null) {
			
			__eventMap = new Map ();
			__iterators = new Map ();
			
		}
		
		if (!__eventMap.exists (type)) {
			
			var list = new Array<Listener> ();
			list.push (new Listener (listener, useCapture, priority));
			
			var iterator = new DispatchIterator (list);
			
			__eventMap.set (type, list);
			__iterators.set (type, [ iterator ]);
			
		} else {
			
			var list = __eventMap.get (type);
			
			for (i in 0...list.length) {
				
				if (list[i].match (listener, useCapture)) return;
				
			}
			
			var iterators = __iterators.get (type);
			
			for (iterator in iterators) {
				
				if (iterator.active) {
					
					iterator.copy ();
					
				}
				
			}
			
			__addListenerByPriority(list, new Listener (listener, useCapture, priority));
						
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
		
		if (__eventMap == null || listener == null) return;
		
		var list = __eventMap.get (type);
		if (list == null) return;
		
		var iterators = __iterators.get (type);
		
		for (i in 0...list.length) {
			
			if (list[i].match (listener, useCapture)) {
				
				for (iterator in iterators) {
					
					iterator.remove (list[i], i);
					
				}
				
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
		
		if (__eventMap == null || event == null) return true;
		
		var type = event.type;
		
		var list = __eventMap.get (type);
		if (list == null) return true;
		
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
		
		var iterators = __iterators.get (type);
		var iterator = iterators[0];
		
		if (iterator.active) {
			
			iterator = new DispatchIterator (list);
			iterators.push (iterator);
			
		}
		
		iterator.reset (list);
		
		for (listener in iterator) {
			
			if (listener == null) continue;
			
			if (listener.useCapture == capture) {
				
				//listener.callback (event.clone ());
				listener.callback (event);
				
				if (event.__isCanceledNow) {
					
					break;
					
				}
				
			}
			
		}
		
		if (iterator != iterators[0]) {
			
			iterators.remove (iterator);
			
		}
		
		return true;
		
	}
	
	
	private function __removeAllListeners ():Void {
		
		__eventMap = null;
		__iterators = null;
		
	}
	
	
	private function __addListenerByPriority(list: Array<Listener>, listener: Listener): Void {

		var numElements: Int = list.length;
		var addAtPosition: Int = numElements;	

		for (i in 0...numElements) {

			if (list[i].priority < listener.priority) {

				addAtPosition = i;

				break;	

			}

		}

		list.insert(addAtPosition, listener);
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) private class DispatchIterator {
	
	
	public var active:Bool;
	public var index (default, null):Int;
	
	private var isCopy:Bool;
	private var list:Array<Listener>;
	
	
	public function new (list:Array<Listener>) {
		
		this.list = list;
		index = list.length;
		
	}
	
	
	public function copy ():Void {
		
		if (!isCopy) {
			
			list = list.copy ();
			isCopy = true;
			
		}
		
	}
	
	
	public function hasNext ():Bool {
		
		if (index < list.length) {
			
			return true;
			
		} else {
			
			active = false;
			return false;
			
		}
		
	}
	
	
	public function next ():Listener {
		
		return list[index++];
		
	}
	
	
	public function remove (listener:Listener, listIndex:Int):Void {
		
		if (active) {
			
			if (!isCopy) {
				
				if (listIndex < index) {
					
					index--;
					
				}
				
			} else {
				
				for (i in index...list.length) {
					
					if (list[i] == listener) {
						
						list.splice (i, 1);
						break;
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	public function reset (list:Array<Listener>):Void {
		
		this.list = list;
		
		active = true;
		isCopy = false;
		index = 0;
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


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