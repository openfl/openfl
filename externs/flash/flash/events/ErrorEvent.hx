package flash.events;

#if flash
import openfl.events.EventType;

extern class ErrorEvent extends TextEvent
{
	public static var ERROR(default, never):EventType<ErrorEvent>;
	@:require(flash10_1) public var errorID(default, never):Int;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0):Void;
	public override function clone():ErrorEvent;
}
#else
typedef ErrorEvent = openfl.events.ErrorEvent;
#end
