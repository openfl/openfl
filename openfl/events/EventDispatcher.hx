package openfl.events;


//import haxe.PosInfos; // for assert
import openfl.events.EventPhase;
import openfl.events.IEventDispatcher;

@:access(openfl.events.Event)

class EventDispatcher implements IEventDispatcher {
	
	
	private var __typeInfos:Map<String, EventTypeInfo>;
	private var __targetDispatcher:IEventDispatcher;
	
	
	public function new (target:IEventDispatcher = null):Void {
		
		if (target != null) {
			
			__targetDispatcher = target;
			
		}
		
	}
	
	
	/* private static function assert (cond:Bool, ?pos:haxe.PosInfos):Void {
		
		if (!cond) {
			trace ("Assert in " + pos.className+"::" + pos.methodName, pos);
		}
		
	} */
	
	
	/* private function assertTypeInvariants (type:String, ?pos:haxe.PosInfos):Void {
		var typeInfo = getTypeInfo (type);
		if (typeInfo != null) {
			
			// listeners list is always non-null (but may be empty temporarily)
			assert (typeInfo.listeners != null, pos);
			
			// lists are always separate, never referring to the same thing
			assert (typeInfo.listeners != typeInfo.newListeners, pos);
			
			// when not dispatching, newListeners is always null
			assert (typeInfo.dispatching || (typeInfo.newListeners == null), pos);
			
		}
		
	} */
	
	
	private function __getList(type:String, mode:GetListMode):Array<Listener> {
		
		if (__typeInfos == null) {
			
			if (mode == Add) {
				
				// Create missing map only if we're about to add.
				__typeInfos = new Map ();
				
			} else {
				
				// No map present, therefore no types, therefore no lists.
				return null;
				
			}
			
		}
		
		// Map exists, look up info.
		var typeInfo = __typeInfos.get (type);
		
		if (typeInfo == null) {
			
			if (mode == Add) {
				
				// Create missing info only if we're about to add.
				typeInfo = new EventTypeInfo();
				__typeInfos.set (type, typeInfo);
				
			} else {
				
				// No typeinfo for this type present.
				return null;
				
			}
			
		}
		
		// If dispatching, try newListeners first.
		if (typeInfo.dispatching && (typeInfo.newListeners != null)) {
			
			// Found a newListeners.
			// Something has already started mutation since
			// dispatch started, and we're on newListeners.
			
			if (mode == ReadCopy) {
				
				// We're about to return a newListeners list,
				// which may mutate in listener callbacks.
				// Return a copy.
				return typeInfo.newListeners.copy ();
				
			} else {
			
				// No risk of user callbacks in these modes
				// (Add, Remove, or Read, but not ReadCopy),
				// and we may need to mutate (Add or Remove);
				// return the actual list.
				return typeInfo.newListeners;
			}
			
		}
		
		// Haven't found a list yet.  Use original listeners.
		var isWrite = (mode == Add) || (mode == Remove);
		if (typeInfo.dispatching && isWrite) {
			
			// Dispatching, and we're about to mutate.
			// Copy to newListeners and return that instead.
			typeInfo.newListeners = typeInfo.listeners.copy ();
			return typeInfo.newListeners;
			
		} else {
		
			// Found, and no chance of this mutating out from under us:
			// We're either not yet dispatching (and if we're about to,
			// we'll only mutate newListeners entries), or we're not
			// writing.
			// Return as-is.
			return typeInfo.listeners;
			
		}
		
	}
	
	
	private function getTypeInfo (type:String):EventTypeInfo {
		
		if (__typeInfos == null) return null;
		return __typeInfos.get (type);
		
	}
	
	
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		var list = __getList (type, Add);
		//assert( list != null ); // non-null in Add mode; autovivifies map / entry / list.
		//assert ((list == getTypeInfo (type).listeners) || (list == getTypeInfo (type).newListeners)); // not a copy
		//assert (getTypeInfo (type).dispatching || (list == getTypeInfo (type).listeners)); // always listeners when not dispatching
		//assertTypeInvariants (type);
		
		for (i in 0...list.length) {
			
			if (Reflect.compareMethods (list[i].callback, listener)) return;
			
		}
		
		list.push (new Listener (listener, useCapture, priority));
		list.sort (__sortByPriority);
		
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
		
		var list = __getList (type, Read);
		//assert ((list == null) || (list == getTypeInfo (type).listeners) || (list == getTypeInfo (type).newListeners)); // not a copy
		//assertTypeInvariants (type);
		return ((list != null) && (list.length > 0));
		
	}
	
	
	public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		
		var list = __getList (type, Remove);
		if (list == null) return; // may be null
		//assert ((list == getTypeInfo (type).listeners) || (list == getTypeInfo (type).newListeners)); // not a copy
		//assert (getTypeInfo (type).dispatching || (list == getTypeInfo (type).listeners)); // always listeners when not dispatching
		//assertTypeInvariants (type);
		
		
		for (i in 0...list.length) {
			
			if (list[i].match (listener, useCapture)) {
				
				list.splice (i, 1);
				break;
				
			}
			
		}
		
		__cleanupType (type);
		
	}
	
	private function __cleanupType (type:String, ?typeInfo:EventTypeInfo = null) {
		
		//assert ((typeInfo == null) || (getTypeInfo (type) == typeInfo));
		//assertTypeInvariants (type);
		
		if (typeInfo == null) {
			
			typeInfo = getTypeInfo (type);
			
		}
		
		if (typeInfo.dispatching) {
			
			// No cleanups while dispatching.
			return;
			
		}
			
		if (typeInfo.listeners.length == 0) {
			
			// Not dispatching, and the original listeners list is empty.
			// No need to keep info for this type anymore;
			// no type info = not dispatching.
			__typeInfos.remove (type);
			
		}
		
		if (!__typeInfos.iterator ().hasNext ()) {
			
			// No types remaining.
			__typeInfos = null;
			
		}
		
		//assertTypeInvariants (type);
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
		
		if (event == null) return false;
		
		var type = event.type;
		var list = __getList (type, ReadCopy);
		if ((list == null) || (list.length == 0)) return false;
		
		// Safe to assume typeInfo exists if getList returned non-NULL.
		var typeInfo = getTypeInfo (type);

		// Remember if we were outermost dispatch,
		// then set dispatching.
		var outermostDispatch = (typeInfo.dispatching == false);
		typeInfo.dispatching = true;
		
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
			
			//assert (listener == list[index]); // should not have mutated
			++index;
		}
		
		if (outermostDispatch) {
			
			// Swap any newListeners back into listeners as appropriate.
			if (typeInfo.newListeners != null) {
				
				typeInfo.listeners = typeInfo.newListeners;
				typeInfo.newListeners = null;
				
			}
			
			// No longer dispatching.
			typeInfo.dispatching = false;
			__cleanupType (type, typeInfo);
			
		}
		
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


private enum GetListMode {
	/**
	 * Return a list suitable for local use only
	 * (e.g. "has" tests).
	 * May mutate if user code is called.
	 * May return null or empty list.
	 */
	Read;
	/**
	 * Return a list suitable for iterating over and calling
	 * callbacks and other unknown code.
	 * May be a copy if there's any risk of mutation.
	 * May return null or empty list.
	 */
	ReadCopy;
	
	/**
	 * Create (if needed) and return a list suitable for insertion
	 * and sorting.
	 * May mutate if user code is called.
	 * Will never return null, may return empty list.
	 */
	Add;
	
	/**
	 * Return a list suitable for removal of one or more elements.
	 * May mutate if user code is called.
	 * May return null or empty list.
	 */
	Remove;
}


private class EventTypeInfo {
	
	public var dispatching:Bool;
	public var listeners:Array<Listener>; // never null
	public var newListeners:Array<Listener>; // always null when !dispatching
	
	public function new ():Void {
		dispatching = false;
		listeners = new Array<Listener>();
		newListeners = null;
	}
	
}
