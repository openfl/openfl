package flash.events;

#if flash
import openfl.events.EventType;

extern class NetStatusEvent extends Event
{
	public static var NET_STATUS(default, never):EventType<NetStatusEvent>;

	#if (haxe_ver < 4.3)
	public var info:Dynamic;
	#else
	@:flash.property var info(get, set):Dynamic;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, info:Dynamic = null);
	public override function clone():NetStatusEvent;

	#if (haxe_ver >= 4.3)
	private function get_info():Dynamic;
	private function set_info(value:Dynamic):Dynamic;
	#end
}
#else
typedef NetStatusEvent = openfl.events.NetStatusEvent;
#end
