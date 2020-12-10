package openfl.events;

#if !flash
interface IEventDispatcher
{
	public function addEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent(event:Event):Bool;
	public function hasEventListener(type:String):Bool;
	public function removeEventListener<T>(type:EventType<T>, listener:T->Void, useCapture:Bool = false):Void;
	public function willTrigger(type:String):Bool;
}
#else
typedef IEventDispatcher = flash.events.IEventDispatcher;
#end
