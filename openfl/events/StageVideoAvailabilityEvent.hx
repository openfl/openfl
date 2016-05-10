package openfl.events; #if (display || !flash)

/**
 * ...
 * @author P.J.Shand
 */
class StageVideoAvailabilityEvent extends Event
{
	public static var STAGE_VIDEO_AVAILABILITY:String = "stageVideoAvailability";
	
	private var _availability:String;
	public var availability(get, null):String;
	
	private var _driver:String;
	public var driver(get, null):String;
	
	private var _reason:String;
	public var reason(get, null):String;
	
	public function new(type:String, bubbles:Bool=false, cancelable:Bool=false, availability:String = null) 
	{
		super(type, bubbles, cancelable);
		_availability = availability;
	}
	
	private function get_availability():String
	{
		return _availability;
	}
	
	private function get_driver():String
	{
		return _driver;
	}
	
	private function get_reason():String
	{
		return _reason;
	}
	
}

#else
typedef StageVideoAvailabilityEvent = flash.events.StageVideoAvailabilityEvent;
#end