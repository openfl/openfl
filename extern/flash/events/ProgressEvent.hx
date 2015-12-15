package flash.events; #if (!display && flash)


extern class ProgressEvent extends Event {
	
	
	public static var PROGRESS:String;
	public static var SOCKET_DATA:String;
	public var bytesLoaded:Float;
	public var bytesTotal:Float;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0);
	
	
}


#else
typedef ProgressEvent = openfl.events.ProgressEvent;
#end