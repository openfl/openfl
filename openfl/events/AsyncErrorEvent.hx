package openfl.events; #if !flash


import haxe.io.Error;


class AsyncErrorEvent extends ErrorEvent {
	
	
	public static var ASYNC_ERROR:String = "asyncError";
	
	public var error:Error;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", error:Error = null):Void {
		
		super (type, bubbles, cancelable);
		
		this.text = text;
		this.error = error;
		
	}
	
	
}


#else
typedef AsyncErrorEvent = flash.events.AsyncErrorEvent;
#end