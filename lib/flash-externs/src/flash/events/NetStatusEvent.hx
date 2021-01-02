package flash.events;

#if flash
import openfl.events.EventType;

extern class NetStatusEvent extends Event
{
	public static var NET_STATUS(default, never):EventType<NetStatusEvent>;
	public var info:Dynamic;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, info:Dynamic = null);
	public override function clone():NetStatusEvent;
}
#else
typedef NetStatusEvent = openfl.events.NetStatusEvent;
#end
