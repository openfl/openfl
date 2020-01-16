package openfl.events;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/events/UncaughtErrorEvents", "default")
#end
extern class UncaughtErrorEvents extends EventDispatcher
{
	public function new();
}
#else
typedef UncaughtErrorEvents = flash.events.UncaughtErrorEvents;
#end
