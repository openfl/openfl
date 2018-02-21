package openfl.events;


class FullScreenEvent extends ActivityEvent {
	
	
	public static inline var FULL_SCREEN = "fullScreen";
	public static inline var FULL_SCREEN_INTERACTIVE_ACCEPTED = "fullScreenInteractiveAccepted";
	
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
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("FullscreenEvent",  [ "type", "bubbles", "cancelable", "fullscreen", "interactive" ]);
		
	}
	
	
}