package openfl.events;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.events.Event)
class EventDispatcher implements IEventDispatcher
{
	@:noCompletion private var __eventMap:Map<String, Array<Listener>>;
	@:noCompletion private var __iterators:Map<String, Array<DispatchIterator>>;
	@:noCompletion private var __targetDispatcher:IEventDispatcher;

	public function new(target:IEventDispatcher = null):Void
	{
		if (target != null)
		{
			__targetDispatcher = target;
		}
	}

	public function addEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		if (listener == null) return;

		if (__eventMap == null)
		{
			__eventMap = new Map();
			__iterators = new Map();
		}

		if (!__eventMap.exists(type))
		{
			var list = new Array<Listener>();
			list.push(new Listener(listener, useCapture, priority));

			var iterator = new DispatchIterator(list);

			__eventMap.set(type, list);
			__iterators.set(type, [iterator]);
		}
		else
		{
			var list = __eventMap.get(type);

			for (i in 0...list.length)
			{
				if (list[i].match(listener, useCapture)) return;
			}

			var iterators = __iterators.get(type);

			for (iterator in iterators)
			{
				if (iterator.active)
				{
					iterator.copy();
				}
			}

			__addListenerByPriority(list, new Listener(listener, useCapture, priority));
		}
	}

	public function dispatchEvent(event:Event):Bool
	{
		if (__targetDispatcher != null)
		{
			event.target = __targetDispatcher;
		}
		else
		{
			event.target = this;
		}

		return __dispatchEvent(event);
	}

	public function hasEventListener(type:String):Bool
	{
		if (__eventMap == null) return false;

		return __eventMap.exists(type);
	}

	public function removeEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false):Void
	{
		if (__eventMap == null || listener == null) return;

		var list = __eventMap.get(type);
		if (list == null) return;

		var iterators = __iterators.get(type);

		for (i in 0...list.length)
		{
			if (list[i].match(listener, useCapture))
			{
				for (iterator in iterators)
				{
					iterator.remove(list[i], i);
				}

				list.splice(i, 1);
				break;
			}
		}

		if (list.length == 0)
		{
			__eventMap.remove(type);
			__iterators.remove(type);
		}

		if (!__eventMap.iterator().hasNext())
		{
			__eventMap = null;
			__iterators = null;
		}
	}

	public function toString():String
	{
		var full = Type.getClassName(Type.getClass(this));
		var short = full.split(".").pop();
		return "[object " + short + "]";
	}

	public function willTrigger(type:String):Bool
	{
		return hasEventListener(type);
	}

	@:noCompletion private function __dispatchEvent(event:Event):Bool
	{
		if (__eventMap == null || event == null) return true;

		var type = event.type;

		var list = __eventMap.get(type);
		if (list == null) return true;

		if (event.target == null)
		{
			if (__targetDispatcher != null)
			{
				event.target = __targetDispatcher;
			}
			else
			{
				event.target = this;
			}
		}

		event.currentTarget = this;

		var capture = (event.eventPhase == EventPhase.CAPTURING_PHASE);

		var iterators = __iterators.get(type);
		var iterator = iterators[0];

		if (iterator.active)
		{
			iterator = new DispatchIterator(list);
			iterators.push(iterator);
		}

		iterator.start();

		for (listener in iterator)
		{
			if (listener == null) continue;

			if (listener.useCapture == capture)
			{
				// listener.callback (event.clone ());
				listener.callback(event);

				if (event.__isCanceledNow)
				{
					break;
				}
			}
		}

		iterator.stop();

		if (iterator != iterators[0])
		{
			iterators.remove(iterator);
		}
		else
		{
			iterator.reset(list);
		}

		return !event.isDefaultPrevented();
	}

	@:noCompletion private function __removeAllListeners():Void
	{
		__eventMap = null;
		__iterators = null;
	}

	@:noCompletion private function __addListenerByPriority(list:Array<Listener>, listener:Listener):Void
	{
		var numElements:Int = list.length;
		var addAtPosition:Int = numElements;

		for (i in 0...numElements)
		{
			if (list[i].priority < listener.priority)
			{
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
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) private class DispatchIterator
{
	public var active:Bool;
	public var index(default, null):Int;

	@:noCompletion private var isCopy:Bool;
	@:noCompletion private var list:Array<Listener>;

	public function new(list:Array<Listener>)
	{
		active = false;
		reset(list);
	}

	public function copy():Void
	{
		if (!isCopy)
		{
			list = list.copy();
			isCopy = true;
		}
	}

	public function hasNext():Bool
	{
		return index < list.length;
	}

	public function next():Listener
	{
		return list[index++];
	}

	public function remove(listener:Listener, listIndex:Int):Void
	{
		if (active)
		{
			if (!isCopy)
			{
				if (listIndex < index)
				{
					index--;
				}
			}
			else
			{
				for (i in index...list.length)
				{
					if (list[i] == listener)
					{
						list.splice(i, 1);
						break;
					}
				}
			}
		}
	}

	public function reset(list:Array<Listener>):Void
	{
		this.list = list;

		isCopy = false;
		index = 0;
	}

	public function start():Void
	{
		active = true;
	}

	public function stop():Void
	{
		active = false;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class Listener
{
	public var callback:Dynamic->Void;
	public var priority:Int;
	public var useCapture:Bool;

	public function new(callback:Dynamic->Void, useCapture:Bool, priority:Int)
	{
		this.callback = callback;
		this.useCapture = useCapture;
		this.priority = priority;
	}

	public function match(callback:Dynamic->Void, useCapture:Bool):Bool
	{
		#if hl // https://github.com/HaxeFoundation/hashlink/issues/301
		return ((Reflect.compareMethods(this.callback, callback) || Reflect.compare(this.callback, callback) == 0)
			&& this.useCapture == useCapture);
		#else
		return (Reflect.compareMethods(this.callback, callback) && this.useCapture == useCapture);
		#end
	}
}
#else
typedef EventDispatcher = flash.events.EventDispatcher;
#end
