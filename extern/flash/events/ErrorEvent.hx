package flash.events; #if (!display && flash)


extern class ErrorEvent extends TextEvent {
	
	
	public static var ERROR (default, never):String;
	
	@:require(flash10_1) public var errorID (default, null):Int;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0):Void;
	
	
}


#else
typedef ErrorEvent = openfl.events.ErrorEvent;
#end