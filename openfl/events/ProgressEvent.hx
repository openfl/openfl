package openfl.events; #if !flash


class ProgressEvent extends Event {
	
	
	public static var PROGRESS:String = "progress";
	public static var SOCKET_DATA:String = "socketData";
	
	public var bytesLoaded:Float;
	public var bytesTotal:Float;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0) {
		
		super (type, bubbles, cancelable);
		
		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;
		
	}
	
	
	public override function clone ():Event {
		
		return new ProgressEvent (type, bubbles, cancelable, bytesLoaded, bytesTotal);
		
	}
	
	
	public override function toString ():String {
		
		return "[ProgressEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " bytesLoaded=" + bytesLoaded + " bytesTotal=" + bytesTotal + "]";
		
	}
	
	
}


#else
typedef ProgressEvent = flash.events.ProgressEvent;
#end