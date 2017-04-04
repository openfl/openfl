package format.swf.events;

import flash.events.Event;

class SWFErrorEvent extends Event
{
	public static inline var ERROR:String = "error";

	public static inline var REASON_EOF:String = "eof";
	
	public var reason:String;
	
	public function new(type:String, reason:String, bubbles:Bool=false, cancelable:Bool=false)
	{
		super(type, bubbles, cancelable);
		this.reason = reason;
	}
	
	override public function clone():Event {
		return new SWFErrorEvent(type, reason, bubbles, cancelable);
	}
	
	override public function toString():String {
		return "[SWFErrorEvent] reason: " + reason;
	}
}