package openfl.events; #if (display || !flash)

/**
 * ...
 * @author P.J.Shand
 */
class StageVideoEvent extends Event
{
	public static var RENDER_STATUS_ACCELERATED:String = "accelerated";
	public static var RENDER_STATUS_SOFTWARE:String = "software";
	public static var RENDER_STATUS_UNAVAILABLE:String = "unavailable";
	public static var RENDER_STATE:String = "renderState";
	
	private var _colorSpace:String;
	public var colorSpace(get, null):String;
	private var _status:String;
	public var status(get, null):String;
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:String = null, colorSpace:String = null) 
	{
		super(type, bubbles, cancelable);
		_colorSpace = colorSpace;
		_status = status;
	}
	
	private function get_colorSpace():String
	{
		return _colorSpace;
	}
	
	private function get_status():String
	{
		return _status;
	}
}

#else
typedef StageVideoEvent = flash.events.StageVideoEvent;
#end