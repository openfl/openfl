package openfl.events; #if !flash


class ErrorEvent extends TextEvent {
	
	
	public static var ERROR:String = "error";
	
	public var errorID (default, null):Int;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0):Void {
		
		super (type, bubbles, cancelable, text);
		errorID = id;
		
	}
	
	
	public override function clone ():Event {
		
		return new ErrorEvent (type, bubbles, cancelable, text, errorID);
		
	}
	
	
	public override function toString ():String {
		
		return "[ErrorEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " text=" + text + " errorID=" + errorID + "]";
		
	}
	
	
}


#else
typedef ErrorEvent = flash.events.ErrorEvent;
#end