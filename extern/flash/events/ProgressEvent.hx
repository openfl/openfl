package flash.events; #if (!display && flash)


extern class ProgressEvent extends Event {
	
	
	public static var PROGRESS (default, never):String;
	public static var SOCKET_DATA (default, never):String;
	public var bytesLoaded:Float;
	public var bytesTotal:Float;
	
	#if (flash && air)
	static var STANDARD_OUTPUT_DATA : String;
	#end
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0);
	
	
}


#else
typedef ProgressEvent = openfl.events.ProgressEvent;
#end