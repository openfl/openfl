package openfl.events; #if (display || !flash)


extern class FullScreenEvent extends ActivityEvent {
	
	
	public static var FULL_SCREEN:String;
	public static var FULL_SCREEN_INTERACTIVE_ACCEPTED:String;
	
	public var fullScreen:Bool;
	public var interactive:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false);
	
	
}


#else
typedef FullScreenEvent = flash.events.FullScreenEvent;
#end