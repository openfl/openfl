package openfl.events; #if (!display && !flash)


import haxe.io.Error;


class AsyncErrorEvent extends ErrorEvent {
	
	
	public static var ASYNC_ERROR = "asyncError";
	
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
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("AsyncErrorEvent",  [ "type", "bubbles", "cancelable", "text", "error" ]);
		
	}
	
	
}


#else


import haxe.io.Error;

#if flash
@:native("flash.events.AsyncErrorEvent")
#end


extern class AsyncErrorEvent extends ErrorEvent {
	
	
	public static var ASYNC_ERROR:String;
	
	public var error:Error;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", error:Error = null);
	
	
}


#end