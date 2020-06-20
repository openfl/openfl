package openfl.events;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class UncaughtErrorEvents extends EventDispatcher
{
	public function new()
	{
		super();
	}
}
#else
typedef UncaughtErrorEvents = flash.events.UncaughtErrorEvents;
#end
