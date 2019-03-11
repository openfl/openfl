package flash.events;

#if flash
import openfl.events.EventType;

extern class SecurityErrorEvent extends ErrorEvent
{
	public static var SECURITY_ERROR(default, never):EventType<SecurityErrorEvent>;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0);
	public override function clone():SecurityErrorEvent;
}
#else
typedef SecurityErrorEvent = openfl.events.SecurityErrorEvent;
#end
