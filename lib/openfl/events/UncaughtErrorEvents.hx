package openfl.events; #if (display || !flash)


@:jsRequire("openfl/events/UncaughtErrorEvents", "default")

extern class UncaughtErrorEvents extends EventDispatcher {
	
	
	public function new ();
	
	
}


#else
typedef UncaughtErrorEvents = flash.events.UncaughtErrorEvents;
#end