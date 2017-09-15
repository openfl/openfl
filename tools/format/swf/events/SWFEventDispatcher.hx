package format.swf.events;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

class SWFEventDispatcher implements IEventDispatcher
{
	private var dispatcher:EventDispatcher;
	
	public function new() {
		dispatcher = new EventDispatcher(this);
	}
	
	public function addEventListener(type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	public function removeEventListener(type:String, listener:Dynamic, useCapture:Bool = false):Void {
		dispatcher.removeEventListener(type, listener, useCapture);
	}
	public function dispatchEvent(event:Event):Bool {
		return dispatcher.dispatchEvent(event);
	}
	public function hasEventListener(type:String):Bool {
		return dispatcher.hasEventListener(type);
	}
	public function willTrigger(type:String):Bool {
		return dispatcher.willTrigger(type);
	}
}