package flash.events; #if (!display && flash)


extern class IOErrorEvent extends ErrorEvent {
	
	
	#if flash
	@:noCompletion @:dox(hide) public static var DISK_ERROR:String;
	#end
	
	public static var IO_ERROR:String;
	
	#if flash
	@:noCompletion @:dox(hide) public static var NETWORK_ERROR:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var VERIFY_ERROR:String;
	#end
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, text:String = "", id:Int = 0);
	
	
}


#else
typedef IOErrorEvent = openfl.events.IOErrorEvent;
#end