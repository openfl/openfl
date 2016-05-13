package flash.events; #if (!display && flash)


extern class DataEvent extends TextEvent {
	
	
	public static var DATA (default, never):String;
	public static var UPLOAD_COMPLETE_DATA (default, never):String;
	
	public var data:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "");
	
	
}


#else
typedef DataEvent = openfl.events.DataEvent;
#end