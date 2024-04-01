package flash.events;

#if flash
import openfl.events.EventType;
import openfl.net.URLRequestHeader;

extern class HTTPStatusEvent extends Event
{
	@:require(flash10_1) public static var HTTP_RESPONSE_STATUS(default, never):EventType<HTTPStatusEvent>;
	public static var HTTP_STATUS(default, never):EventType<HTTPStatusEvent>;

	#if (haxe_ver < 4.3)
	public var redirected:Bool;
	@:require(flash10_1) public var responseHeaders:Array<URLRequestHeader>;
	@:require(flash10_1) public var responseURL:String;
	public var status(default, never):Int;
	#else
	@:flash.property var redirected(get, set):Bool;
	@:flash.property @:require(flash10_1) var responseHeaders(get, set):Array<URLRequestHeader>;
	@:flash.property @:require(flash10_1) var responseURL(get, set):String;
	@:flash.property var status(get, never):Int;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:Int = 0, redirected:Bool = false):Void;
	public override function clone():HTTPStatusEvent;

	#if (haxe_ver >= 4.3)
	private function get_redirected():Bool;
	private function get_responseHeaders():Array<URLRequestHeader>;
	private function get_responseURL():String;
	private function get_status():Int;
	private function set_redirected(value:Bool):Bool;
	private function set_responseHeaders(value:Array<URLRequestHeader>):Array<URLRequestHeader>;
	private function set_responseURL(value:String):String;
	#end
}
#else
typedef HTTPStatusEvent = openfl.events.HTTPStatusEvent;
#end
