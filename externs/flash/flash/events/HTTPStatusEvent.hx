package flash.events;

#if flash
import openfl.events.EventType;
import openfl.net.URLRequestHeader;

extern class HTTPStatusEvent extends Event
{
	@:require(flash10_1) public static var HTTP_RESPONSE_STATUS(default, never):EventType<HTTPStatusEvent>;
	public static var HTTP_STATUS(default, never):EventType<HTTPStatusEvent>;
	public var redirected:Bool;
	@:require(flash10_1) public var responseHeaders:Array<URLRequestHeader>;
	@:require(flash10_1) public var responseURL:String;
	public var status(default, never):Int;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:Int = 0, redirected:Bool = false):Void;
	public override function clone():HTTPStatusEvent;
}
#else
typedef HTTPStatusEvent = openfl.events.HTTPStatusEvent;
#end
