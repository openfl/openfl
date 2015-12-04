package openfl.events; #if (!display && !flash)


class UncaughtErrorEvents extends EventDispatcher {
	
	
	public function new () {
		
		super ();
		
	}
	
	
}


#else


#if flash
@:native("flash.events.UncaughtErrorEvents")
@:require(flash10_1)
#end

extern class UncaughtErrorEvents extends EventDispatcher {
	
	
	public function new ();
	
	
}


#end