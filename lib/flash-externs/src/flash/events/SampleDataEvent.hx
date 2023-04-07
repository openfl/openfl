package flash.events;

#if flash
import openfl.events.EventType;
import openfl.utils.ByteArray;

extern class SampleDataEvent extends Event
{
	public static var SAMPLE_DATA(default, never):EventType<SampleDataEvent>;

	#if (haxe_ver < 4.3)
	public var data:ByteArray;
	public var position:Float;
	#else
	@:flash.property var data(get, set):ByteArray;
	@:flash.property var position(get, set):Float;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false);
	public override function clone():SampleDataEvent;

	#if (haxe_ver >= 4.3)
	private function get_data():ByteArray;
	private function get_position():Float;
	private function set_data(value:ByteArray):ByteArray;
	private function set_position(value:Float):Float;
	#end
}
#else
typedef SampleDataEvent = openfl.events.SampleDataEvent;
#end
