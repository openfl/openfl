package flash.events;

#if flash
import openfl.events.EventType;

extern class UncaughtErrorEvent extends ErrorEvent
{
	public static var UNCAUGHT_ERROR(default, never):EventType<UncaughtErrorEvent>;

	#if (haxe_ver < 4.3)
	public var error(default, never):Dynamic;
	#else
	@:flash.property var error(get, never):Dynamic;
	#end

	public function new(type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null);
	public override function clone():UncaughtErrorEvent;

	#if (haxe_ver >= 4.3)
	private function get_error():Dynamic;
	#end
}
#else
typedef UncaughtErrorEvent = openfl.events.UncaughtErrorEvent;
#end
