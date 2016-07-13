package flash.events; #if (!display && flash)


@:require(flash10_1)

extern class UncaughtErrorEvents extends EventDispatcher {
	
	
	public function new ();
	
	
}


#else
typedef UncaughtErrorEvents = openfl.events.UncaughtErrorEvents;
#end