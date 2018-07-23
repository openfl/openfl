package openfl.events; #if !flash


import haxe.io.Error;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class AsyncErrorEvent extends ErrorEvent {
	
	
	public static inline var ASYNC_ERROR = "asyncError";
	
	public var error:Error;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", error:Error = null):Void {
		
		super (type, bubbles, cancelable);
		
		this.text = text;
		this.error = error;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new AsyncErrorEvent (type, bubbles, cancelable, text, error);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("AsyncErrorEvent",  [ "type", "bubbles", "cancelable", "text", "error" ]);
		
	}
	
	
}


#else
typedef AsyncErrorEvent = flash.events.AsyncErrorEvent;
#end