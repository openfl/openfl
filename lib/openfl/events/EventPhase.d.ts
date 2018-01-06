declare namespace openfl.events {
	
	/**
	 * The EventPhase class provides values for the `eventPhase`
	 * property of the Event class.
	 */
	export enum EventPhase {
		
		AT_TARGET = 2,
		BUBBLING_PHASE = 3,
		CAPTURING_PHASE = 1
		
	}
	
}


export default openfl.events.EventPhase;