package openfl.events;


class HTTPStatusEvent extends Event {
	
	
	public static var HTTP_RESPONSE_STATUS:String = "httpResponseStatus";
	public static var HTTP_STATUS:String = "httpStatus";
	
	public var responseHeaders:Array<Dynamic>;
	public var responseURL:String;
	public var status (default, null):Int;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, status:Int = 0):Void {
		
		this.status = status;
		
		super (type, bubbles, cancelable);
		
	}
	
	
}