package openfl.events;


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
	
	
}