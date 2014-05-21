package openfl.events;


class ProgressEvent extends Event {
	
	
	public static inline var PROGRESS = "progress";
	public static inline var SOCKET_DATA = "socketData";
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Int = 0, bytesTotal:Int = 0) {
		
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