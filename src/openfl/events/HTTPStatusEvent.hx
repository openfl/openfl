package openfl.events;


import openfl.net.URLRequestHeader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class HTTPStatusEvent extends Event {
	
	
	public static inline var HTTP_RESPONSE_STATUS = "httpResponseStatus";
	public static inline var HTTP_STATUS = "httpStatus";
	
	public var redirected:Bool;
	public var responseHeaders:Array<URLRequestHeader>;
	public var responseURL:String;
	public var status (default, null):Int;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, status:Int = 0, redirected:Bool = false):Void {
		
		this.status = status;
		this.redirected = redirected;
		
		super (type, bubbles, cancelable);
		
	}
	
	
	public override function clone ():Event {
		
		var event = new HTTPStatusEvent (type, bubbles, cancelable, status, redirected);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("HTTPStatusEvent",  [ "type", "bubbles", "cancelable", "status", "redirected" ]);
		
	}
	
	
}