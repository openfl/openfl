package flash.events; #if (!display && flash)


extern class TextEvent extends Event {
	
	
	public static var LINK:String;
	public static var TEXT_INPUT:String;
	
	public var text:String;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "");
	
	
}


#else
typedef TextEvent = openfl.events.TextEvent;
#end