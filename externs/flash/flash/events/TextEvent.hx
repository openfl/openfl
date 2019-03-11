package flash.events;

#if flash
import openfl.events.EventType;

extern class TextEvent extends Event
{
	public static var LINK(default, never):EventType<TextEvent>;
	public static var TEXT_INPUT(default, never):EventType<TextEvent>;
	public var text:String;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "");
	public override function clone():TextEvent;
}
#else
typedef TextEvent = openfl.events.TextEvent;
#end
