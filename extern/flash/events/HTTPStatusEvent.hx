package flash.events; #if (!display && flash)


extern class HTTPStatusEvent extends Event {
	
	
	@:require(flash10_1) public static var HTTP_RESPONSE_STATUS:String;
	public static var HTTP_STATUS:String;
	
	public var redirected:Bool;
	@:require(flash10_1) public var responseHeaders:Array<Dynamic>;
	@:require(flash10_1) public var responseURL:String;
	public var status (default, null):Int;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, status:Int = 0, redirected:Bool = false):Void;
	
	
}


#else
typedef HTTPStatusEvent = openfl.events.HTTPStatusEvent;
#end