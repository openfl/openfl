package flash.events;

#if flash
import openfl.events.EventType;

extern class FullScreenEvent extends ActivityEvent
{
	public static var FULL_SCREEN(default, never):EventType<FullScreenEvent>;
	@:require(flash11_3) public static var FULL_SCREEN_INTERACTIVE_ACCEPTED(default, never):EventType<FullScreenEvent>;
	public var fullScreen:Bool;
	@:require(flash11_3) public var interactive:Bool;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false);
	public override function clone():FullScreenEvent;
}
#else
typedef FullScreenEvent = openfl.events.FullScreenEvent;
#end
