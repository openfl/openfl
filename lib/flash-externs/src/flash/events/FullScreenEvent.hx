package flash.events;

#if flash
import openfl.events.EventType;

extern class FullScreenEvent extends ActivityEvent
{
	public static var FULL_SCREEN(default, never):EventType<FullScreenEvent>;
	@:require(flash11_3) public static var FULL_SCREEN_INTERACTIVE_ACCEPTED(default, never):EventType<FullScreenEvent>;

	#if (haxe_ver < 4.3)
	public var fullScreen:Bool;
	@:require(flash11_3) public var interactive:Bool;
	#else
	@:flash.property var fullScreen(get, never):Bool;
	@:flash.property @:require(flash11_3) var interactive(get, never):Bool;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false, interactive:Bool = false);
	public override function clone():FullScreenEvent;

	#if (haxe_ver >= 4.3)
	private function get_fullScreen():Bool;
	private function get_interactive():Bool;
	#end
}
#else
typedef FullScreenEvent = openfl.events.FullScreenEvent;
#end
