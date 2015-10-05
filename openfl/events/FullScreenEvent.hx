package openfl.events; #if !flash


class FullScreenEvent extends Event {
	
	
	public static var FULL_SCREEN = "fullScreen";
	public static var FULL_SCREEN_INTERACTIVE_ACCEPTED = "fullScreenInteractiveAccepted";
	
	public var fullScreen:Bool;
	public var interactive:Bool;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false) {
		
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
		
		return "[FullscreenEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " fullscreen=" + fullScreen + " interactive=" + interactive + "]";
		
	}
	
	
}


#else
typedef FullScreenEvent = flash.events.FullScreenEvent;
#end