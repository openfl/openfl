package openfl.events; #if (display || !flash)


@:jsRequire("openfl/events/FullScreenEvent", "default")

extern class FullScreenEvent extends ActivityEvent {
	
	
	public static inline var FULL_SCREEN = "fullScreen";
	public static inline var FULL_SCREEN_INTERACTIVE_ACCEPTED = "fullScreenInteractiveAccepted";
	
	public var fullScreen:Bool;
	public var interactive:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false);
	
	
}


#else
typedef FullScreenEvent = flash.events.FullScreenEvent;
#end