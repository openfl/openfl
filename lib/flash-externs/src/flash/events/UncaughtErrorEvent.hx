package flash.events;

#if flash
import openfl.events.EventType;

extern class UncaughtErrorEvent extends ErrorEvent
{
	public static var UNCAUGHT_ERROR(default, never):EventType<UncaughtErrorEvent>;
	public var error(default, never):Dynamic;
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null);
	public override function clone():UncaughtErrorEvent;
}
#else
typedef UncaughtErrorEvent = openfl.events.UncaughtErrorEvent;
#end
