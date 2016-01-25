package flash.events; #if (!display && flash)


extern class IOErrorEvent extends ErrorEvent {
	
	
	#if flash
	@:noCompletion @:dox(hide) public static var DISK_ERROR (default, never):String;
	#end
	
	public static var IO_ERROR (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) public static var NETWORK_ERROR (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var VERIFY_ERROR (default, never):String;
	#end
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, text:String = "", id:Int = 0);
	
	
}


#else
typedef IOErrorEvent = openfl.events.IOErrorEvent;
#end