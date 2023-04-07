package flash.events;

#if flash
import openfl.events.EventType;

extern class IOErrorEvent extends ErrorEvent
{
	public static var DISK_ERROR(default, never):EventType<IOErrorEvent>;
	public static var IO_ERROR(default, never):EventType<IOErrorEvent>;
	public static var NETWORK_ERROR(default, never):EventType<IOErrorEvent>;
	public static var VERIFY_ERROR(default, never):EventType<IOErrorEvent>;
	#if air
	public static var STANDARD_ERROR_IO_ERROR(default, never):EventType<IOErrorEvent>;
	public static var STANDARD_INPUT_IO_ERROR(default, never):EventType<IOErrorEvent>;
	public static var STANDARD_OUTPUT_IO_ERROR(default, never):EventType<IOErrorEvent>;
	#end
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, text:String = "", id:Int = 0);
	public override function clone():IOErrorEvent;
}
#else
typedef IOErrorEvent = openfl.events.IOErrorEvent;
#end
