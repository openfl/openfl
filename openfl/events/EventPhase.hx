package openfl.events; #if !flash


/**
 * The EventPhase class provides values for the <code>eventPhase</code>
 * property of the Event class.
 */
enum EventPhase {
	
	CAPTURING_PHASE;
	AT_TARGET;
	BUBBLING_PHASE;
	
}


#else
typedef EventPhase = flash.events.EventPhase;
#end