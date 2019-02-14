package openfl._internal.utils;

import openfl.events.EventPhase;
import openfl.geom.Point;
import openfl.display.InteractiveObject;
import openfl.events.MouseEvent;
import haxe.ds.ObjectMap;

@:access(openfl.events.MouseEvent)
@SuppressWarnings("checkstyle:FieldDocComment")
class MouseEventPool
{
	public var activeObjects(default, null):Int;
	public var inactiveObjects(default, null):Int;
	public var size(get, set):Null<Int>;

	@:noCompletion private var __inactiveObject0:MouseEvent;
	@:noCompletion private var __inactiveObject1:MouseEvent;
	@:noCompletion private var __inactiveObjectList:List<MouseEvent>;
	@:noCompletion private var __pool:Map<MouseEvent, Bool>;
	@:noCompletion private var __size:Null<Int>;

	public function new(size:Null<Int> = null)
	{
		__pool = cast new ObjectMap();

		activeObjects = 0;
		inactiveObjects = 0;

		__inactiveObject0 = null;
		__inactiveObject1 = null;
		__inactiveObjectList = new List<MouseEvent>();

		if (size != null)
		{
			this.size = size;
		}
	}

	public function add(object:MouseEvent):Void
	{
		if (!__pool.exists(object))
		{
			__pool.set(object, false);
			clean(object);
			__addInactive(object);
		}
	}

	public dynamic function clean(object:MouseEvent):Void
	{
		object.__isCanceled = false;
		object.__isCanceledNow = false;
		object.__preventDefault = false;
		object.eventPhase = EventPhase.AT_TARGET;
	}

	public function clear():Void
	{
		__pool = cast new ObjectMap();

		activeObjects = 0;
		inactiveObjects = 0;

		__inactiveObject0 = null;
		__inactiveObject1 = null;
		__inactiveObjectList.clear();
	}

	public dynamic function create(type:String, stageX:Float, stageY:Float, local:Point, target:InteractiveObject, delta:Int = 0):MouseEvent
	{
		var event = new MouseEvent(type, true, false, null != local ? local.x : 0, null != local ? local.y : 0, null, MouseEvent.__ctrlKey,
			MouseEvent.__altKey, MouseEvent.__shiftKey, MouseEvent.__buttonDown, delta, MouseEvent.__commandKey);
		event.stageX = stageX;
		event.stageY = stageY;
		event.target = target;

		return event;
	}

	public function get(type:String, stageX:Float, stageY:Float, local:Point, target:InteractiveObject):MouseEvent
	{
		var object = null;

		if (inactiveObjects > 0)
		{
			object = __getInactive();
			object.type = type;
			object.bubbles = true;
			object.cancelable = false;
			object.localX = local.x;
			object.localY = local.y;

			object.stageX = stageX;
			object.stageY = stageY;
			object.target = target;
		}
		else if (__size == null || activeObjects < __size)
		{
			object = create(type, stageX, stageY, local, target);

			if (object != null)
			{
				__pool.set(object, true);
				activeObjects++;
			}
		}

		return object;
	}

	public function release(object:MouseEvent):Void
	{
		activeObjects--;

		if (__size == null || activeObjects + inactiveObjects < __size)
		{
			clean(object);
			__addInactive(object);
		}
		else
		{
			__pool.remove(object);
		}
	}

	@:noCompletion private inline function __addInactive(object:MouseEvent):Void
	{
		if (__inactiveObject0 == null)
		{
			__inactiveObject0 = object;
		}
		else if (__inactiveObject1 == null)
		{
			__inactiveObject1 = object;
		}
		else
		{
			__inactiveObjectList.add(object);
		}

		inactiveObjects++;
	}

	@:noCompletion private inline function __getInactive():MouseEvent
	{
		var object = null;

		if (__inactiveObject0 != null)
		{
			object = __inactiveObject0;
			__inactiveObject0 = null;
		}
		else if (__inactiveObject1 != null)
		{
			object = __inactiveObject1;
			__inactiveObject1 = null;
		}
		else
		{
			object = __inactiveObjectList.pop();

			if (__inactiveObjectList.length > 0)
			{
				__inactiveObject0 = __inactiveObjectList.pop();
			}

			if (__inactiveObjectList.length > 0)
			{
				__inactiveObject1 = __inactiveObjectList.pop();
			}
		}

		inactiveObjects--;
		activeObjects++;

		return object;
	}

	@:noCompletion private function __removeInactive(count:Int):Void
	{
		if (count <= 0 || inactiveObjects == 0) return;

		if (__inactiveObject0 != null)
		{
			__pool.remove(__inactiveObject0);
			__inactiveObject0 = null;
			inactiveObjects--;
			count--;
		}

		if (count == 0 || inactiveObjects == 0) return;

		if (__inactiveObject1 != null)
		{
			__pool.remove(__inactiveObject1);
			__inactiveObject1 = null;
			inactiveObjects--;
			count--;
		}

		if (count == 0 || inactiveObjects == 0) return;

		for (object in __inactiveObjectList)
		{
			__pool.remove(object);
			__inactiveObjectList.remove(object);
			inactiveObjects--;
			count--;

			if (count == 0 || inactiveObjects == 0) return;
		}
	}

	// Get & Set Methods
	@:noCompletion private function get_size():Null<Int>
	{
		return __size;
	}

	@:noCompletion private function set_size(value:Null<Int>):Null<Int>
	{
		if (value == null)
		{
			__size = null;
		}
		else
		{
			var current = inactiveObjects + activeObjects;
			__size = value;

			if (current > value)
			{
				__removeInactive(current - value);
			}
			else if (value > current)
			{
				var object;

				for (i in 0...(value - current))
				{
					object = create(MouseEvent.CLICK, 0, 0, null, null);

					if (object != null)
					{
						__pool.set(object, false);
						__inactiveObjectList.add(object);
						inactiveObjects++;
					}
					else
					{
						break;
					}
				}
			}
		}

		return value;
	}
}
