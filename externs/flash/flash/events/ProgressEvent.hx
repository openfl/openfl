package flash.events;

#if flash
import openfl.events.EventType;

extern class ProgressEvent extends Event
{
	public static var PROGRESS(default, never):EventType<ProgressEvent>;
	public static var SOCKET_DATA(default, never):EventType<ProgressEvent>;
	#if air
	public static var STANDARD_ERROR_DATA(default, never):EventType<ProgressEvent>;
	public static var STANDARD_INPUT_PROGRESS(default, never):EventType<ProgressEvent>;
	public static var STANDARD_OUTPUT_DATA(default, never):EventType<ProgressEvent>;
	#end
	public var bytesLoaded:Float;
	public var bytesTotal:Float;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0);
	public override function clone():ProgressEvent;
}
#else
typedef ProgressEvent = openfl.events.ProgressEvent;
#end
