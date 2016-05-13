package flash.events; #if (!display && flash)


extern class FullScreenEvent extends ActivityEvent {
	
	
	public static var FULL_SCREEN (default, never):String;
	@:require(flash11_3) public static var FULL_SCREEN_INTERACTIVE_ACCEPTED (default, never):String;
	
	public var fullScreen:Bool;
	@:require(flash11_3) public var interactive:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false);
	
	
}


#else
typedef FullScreenEvent = openfl.events.FullScreenEvent;
#end