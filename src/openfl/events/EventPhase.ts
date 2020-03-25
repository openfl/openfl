/**
 * The EventPhase class provides values for the `eventPhase`
 * property of the Event class.
 */
export enum EventPhase
{
	/**
		The target phase, which is the second phase of the event flow.
	**/
	AT_TARGET = 2,

	/**
		The bubbling phase, which is the third phase of the event flow.
	**/
	BUBBLING_PHASE = 3,

	/**
		The capturing phase, which is the first phase of the event flow.
	**/
	CAPTURING_PHASE = 1
}

export default EventPhase;
