package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Event
{
	public var bubbles:Bool;
	public var cancelable:Bool;
	public var currentTarget:#if (haxe_ver >= "3.4.2") Any #else IEventDispatcher #end;
	public var eventPhase:EventPhase;
	public var target:#if (haxe_ver >= "3.4.2") Any #else IEventDispatcher #end;
	public var type:String;

	public static var __pool:ObjectPool<Event> = new ObjectPool<Event>(function() return new Event(null), function(event) event._.__init());

	public var __isCanceled:Bool;
	public var __isCanceledNow:Bool;
	public var __preventDefault:Bool;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		this.type = type;
		this.bubbles = bubbles;
		this.cancelable = cancelable;
		eventPhase = EventPhase.AT_TARGET;
	}

	public function clone():Event
	{
		var event = new Event(type, bubbles, cancelable);
		event._.eventPhase = eventPhase;
		event._.target = target;
		event._.currentTarget = currentTarget;
		return event;
	}

	public function formatToString(className:String, p1:String = null, p2:String = null, p3:String = null, p4:String = null, p5:String = null):String
	{
		var parameters = [];
		if (p1 != null) parameters.push(p1);
		if (p2 != null) parameters.push(p2);
		if (p3 != null) parameters.push(p3);
		if (p4 != null) parameters.push(p4);
		if (p5 != null) parameters.push(p5);

		return Reflect.callMethod(this, __formatToString, [className, parameters]);
	}

	public function isDefaultPrevented():Bool
	{
		return __preventDefault;
	}

	public function preventDefault():Void
	{
		if (cancelable)
		{
			__preventDefault = true;
		}
	}

	public function stopImmediatePropagation():Void
	{
		__isCanceled = true;
		__isCanceledNow = true;
	}

	public function stopPropagation():Void
	{
		__isCanceled = true;
	}

	public function toString():String
	{
		return __formatToString("Event", ["type", "bubbles", "cancelable"]);
	}

	public function __formatToString(className:String, parameters:Array<String>):String
	{
		// TODO: Make this a macro function, and handle at compile-time, with rest parameters?

		var output = '[$className';
		var arg:Dynamic = null;

		for (param in parameters)
		{
			arg = Reflect.field(this, param);

			if (Std.is(arg, String))
			{
				output += ' $param="$arg"';
			}
			else
			{
				output += ' $param=$arg';
			}
		}

		output += "]";
		return output;
	}

	public function __init():Void
	{
		// type = null;
		target = null;
		currentTarget = null;
		bubbles = false;
		cancelable = false;
		eventPhase = AT_TARGET;
		__isCanceled = false;
		__isCanceledNow = false;
		__preventDefault = false;
	}
}
