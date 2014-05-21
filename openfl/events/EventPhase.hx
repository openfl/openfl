/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.events;
#if display


/**
 * The EventPhase class provides values for the <code>eventPhase</code>
 * property of the Event class.
 */
@:fakeEnum(UInt) extern enum EventPhase {
	AT_TARGET;
	BUBBLING_PHASE;
	CAPTURING_PHASE;
}


#end
