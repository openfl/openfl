package flash.events;

#if flash
import haxe.io.Error;
import openfl.events.EventType;

extern class AsyncErrorEvent extends ErrorEvent
{
	public static var ASYNC_ERROR(default, never):EventType<AsyncErrorEvent>;
	public var error:Error;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", error:Error = null);
	public override function clone():AsyncErrorEvent;
}
#else
typedef AsyncErrorEvent = openfl.events.AsyncErrorEvent;
#end
