package flash.events;

#if flash
import openfl.events.EventType;

extern class ErrorEvent extends TextEvent
{
	public static var ERROR(default, never):EventType<ErrorEvent>;

	#if (haxe_ver < 4.3)
	@:require(flash10_1) public var errorID(default, never):Int;
	#else
	@:flash.property @:require(flash10_1) var errorID(get, never):Int;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "", id:Int = 0):Void;
	public override function clone():ErrorEvent;

	#if (haxe_ver >= 4.3)
	private function get_errorID():Int;
	#end
}
#else
typedef ErrorEvent = openfl.events.ErrorEvent;
#end
