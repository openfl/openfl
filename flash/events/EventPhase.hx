package flash.events;
#if (flash || display)


/**
 * The EventPhase class provides values for the <code>eventPhase</code>
 * property of the Event class.
 */
@:fakeEnum(Int) extern enum EventPhase {
	AT_TARGET;
	BUBBLING_PHASE;
	CAPTURING_PHASE;
}


#end
