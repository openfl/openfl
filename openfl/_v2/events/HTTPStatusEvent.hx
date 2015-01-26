package openfl._v2.events; #if lime_legacy


class HTTPStatusEvent extends Event {
	
	
	public static var HTTP_STATUS = "httpStatus";
	
	public var status:Int;
	public var responseHeaders : Array<flash.net.URLRequestHeader>;
	public var responseURL:String;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, status:Int = 0) {
		
		super (type, bubbles, cancelable);
		
		this.status = status;
		this.responseHeaders = [];
	}
	
	
	public override function clone ():Event {
		
		return new HTTPStatusEvent (type, bubbles, cancelable, status);
		
	}
	
	
	public override function toString ():String {
		
		return "[HTTPStatusEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " status=" + status + "]";
		
	}
	
	
}


#end