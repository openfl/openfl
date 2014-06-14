package openfl.events; #if !flash


class IOErrorEvent extends ErrorEvent {
	
	
	public static var IO_ERROR = "ioError";
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, text:String = "", id:Int = 0) {
		
		super (type, bubbles, cancelable, text, id);
		
	}
	
	
	public override function clone ():Event {
		
		return new IOErrorEvent (type, bubbles, cancelable, text, errorID);
		
	}
	
	
	public override function toString ():String {
		
		return "[IOErrorEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " text=" + text + " errorID=" + errorID + "]";
		
	}
	
	
}


#else
typedef IOErrorEvent = flash.events.IOErrorEvent;
#end