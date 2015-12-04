package openfl.events; #if (!display && !flash)


class FullScreenEvent extends ActivityEvent {
	
	
	public static var FULL_SCREEN = "fullScreen";
	public static var FULL_SCREEN_INTERACTIVE_ACCEPTED = "fullScreenInteractiveAccepted";
	
	public var fullScreen:Bool;
	public var interactive:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false) {
		
		// TODO: What is the "activating" value supposed to be?
		
		super (type, bubbles, cancelable);
		
		this.fullScreen = fullScreen;
		this.interactive = interactive;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new FullScreenEvent (type, bubbles, cancelable, fullScreen, interactive);
		event.target = target;
		event.currentTarget = currentTarget;
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("FullscreenEvent",  [ "type", "bubbles", "cancelable", "fullscreen", "interactive" ]);
		
	}
	
	
}


#else


#if flash
@:native("flash.events.FullScreenEvent")
#end

extern class FullScreenEvent extends ActivityEvent {
	
	
	public static var FULL_SCREEN:String;
	
	#if flash
	@:require(flash11_3)
	#end
	public static var FULL_SCREEN_INTERACTIVE_ACCEPTED:String;
	
	public var fullScreen:Bool;
	
	#if flash
	@:require(flash11_3)
	#end
	public var interactive:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false);
	
	
}


#end