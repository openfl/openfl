package openfl.events; #if !flash


/**
 * The EventPhase class provides values for the `eventPhase`
 * property of the Event class.
 */
@:enum abstract EventPhase(Int) from Int to Int from UInt to UInt {
	
	public var AT_TARGET = 2;
	public var BUBBLING_PHASE = 3;
	public var CAPTURING_PHASE = 1;
	
}


#else
typedef EventPhase = flash.events.EventPhase;
#end