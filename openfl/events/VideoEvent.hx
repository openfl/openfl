package openfl.events; #if (display || !flash)

import flash.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class VideoEvent extends Event
{
	public static var RENDER_STATE:String = "renderState";
	public static var RENDER_STATUS_ACCELERATED:String = "accelerated";
	public static var RENDER_STATUS_SOFTWARE:String = "software";
	public static var RENDER_STATUS_UNAVAILABLE:String = "unavailable";
	
	private var _status:String;
	public var status(get, null):String;
	
	private var _codecInfo:String;
	public var codecInfo(get, null):String;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:String = null) 
	{
		super(type, bubbles, cancelable);
		_status = status;
	}
	
	private function get_status():String
	{
		return _status;
	}
	
	private function get_codecInfo():String
	{
		return _codecInfo;
	}
	
}

#else
typedef VideoEvent = flash.events.VideoEvent;
#end