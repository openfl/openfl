package openfl.events;


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