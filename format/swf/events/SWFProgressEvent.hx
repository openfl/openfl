package format.swf.events;

import flash.events.Event;

class SWFProgressEvent extends Event
{
	public static inline var PROGRESS:String = "progress";
	public static inline var COMPLETE:String = "complete";
	
	public var progress (get_progress, null):Float;
	public var progressPercent (get_progressPercent, null):Float;
	
	private var processed:Int;
	private var total:Int;
	
	public function new(type:String, processed:Int, total:Int, bubbles:Bool=false, cancelable:Bool=false)
	{
		super(type, bubbles, cancelable);
		this.processed = processed;
		this.total = total;
	}
	
	public function get_progress():Float {
		return processed / total;
	}
	
	public function get_progressPercent():Float {
		return Math.round(progress * 100);
	}
	
	override public function clone():Event {
		return new SWFProgressEvent(type, processed, total, bubbles, cancelable);
	}
	
	override public function toString():String {
		return "[SWFProgressEvent] processed: " + processed + ", total: " + total + " (" + progressPercent + "%)";
	}
}