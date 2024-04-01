package flash.events;

#if flash
import openfl.events.EventType;

extern class DataEvent extends TextEvent
{
	public static var DATA(default, never):EventType<DataEvent>;
	public static var UPLOAD_COMPLETE_DATA(default, never):EventType<DataEvent>;

	#if (haxe_ver < 4.3)
	public var data:String;
	#else
	@:flash.property var data(get, set):String;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, data:String = "");
	public override function clone():DataEvent;

	#if (haxe_ver >= 4.3)
	private function get_data():String;
	private function set_data(value:String):String;
	#end
}
#else
typedef DataEvent = openfl.events.DataEvent;
#end
