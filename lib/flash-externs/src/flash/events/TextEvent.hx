package flash.events;

#if flash
import openfl.events.EventType;

extern class TextEvent extends Event
{
	public static var LINK(default, never):EventType<TextEvent>;
	public static var TEXT_INPUT(default, never):EventType<TextEvent>;

	#if (haxe_ver < 4.3)
	public var text:String;
	#else
	@:flash.property var text(get, set):String;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "");
	public override function clone():TextEvent;

	#if (haxe_ver >= 4.3)
	private function get_text():String;
	private function set_text(value:String):String;
	#end
}
#else
typedef TextEvent = openfl.events.TextEvent;
#end
