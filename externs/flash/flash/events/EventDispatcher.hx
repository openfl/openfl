package flash.events;

import openfl.events.EventType;

#if flash
extern class EventDispatcher implements IEventDispatcher
{
	public function new(target:IEventDispatcher = null):Void;
	public function addEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent(event:Event):Bool;
	public function hasEventListener(type:String):Bool;
	public function removeEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false):Void;
	public function toString():String;
	public function willTrigger(type:String):Bool;
}
#else
typedef EventDispatcher = openfl.events.EventDispatcher;
#end
