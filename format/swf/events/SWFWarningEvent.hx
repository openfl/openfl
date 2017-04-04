package format.swf.events;

import flash.events.Event;

class SWFWarningEvent extends Event
{
	public static inline var WARN_OVERFLOW:String = "overflow";
	public static inline var WARN_UNDERFLOW:String = "underflow";
	
	public var index:Int;
	public var data:Dynamic;
	
	public function new(type:String, index:Int, data:Dynamic = null, bubbles:Bool=false, cancelable:Bool=false)
	{
		super(type, bubbles, cancelable);
		this.index = index;
		this.data = data;
	}
	
	override public function clone():Event {
		return new SWFWarningEvent(type, index, data, bubbles, cancelable);
	}
	
	override public function toString():String {
		return "[SWFWarningEvent] index: " + index;
	}
}