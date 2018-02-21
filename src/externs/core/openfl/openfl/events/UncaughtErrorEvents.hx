package openfl.events; #if (display || !flash)


extern class UncaughtErrorEvents extends EventDispatcher {
	
	
	public function new ();
	
	
}


#else
typedef UncaughtErrorEvents = flash.events.UncaughtErrorEvents;
#end