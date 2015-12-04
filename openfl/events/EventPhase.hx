package openfl.events; #if (!display && !flash)


enum EventPhase {
	
	CAPTURING_PHASE;
	AT_TARGET;
	BUBBLING_PHASE;
	
}


#else


/**
 * The EventPhase class provides values for the <code>eventPhase</code>
 * property of the Event class.
 */

#if flash
@:native("flash.events.EventPhase")
#end

@:fakeEnum(UInt) extern enum EventPhase {
	
	AT_TARGET;
	BUBBLING_PHASE;
	CAPTURING_PHASE;
	
}


#end