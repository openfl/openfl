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

	#if (haxe_ver < 4.3)
	public var bytesLoaded:Float;
	public var bytesTotal:Float;
	#else
	@:flash.property var bytesLoaded(get, set):Float;
	@:flash.property var bytesTotal(get, set):Float;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0);
	public override function clone():ProgressEvent;

	#if (haxe_ver >= 4.3)
	private function get_bytesLoaded():Float;
	private function get_bytesTotal():Float;
	private function set_bytesLoaded(value:Float):Float;
	private function set_bytesTotal(value:Float):Float;
	#end
}
#else
typedef ProgressEvent = openfl.events.ProgressEvent;
#end
