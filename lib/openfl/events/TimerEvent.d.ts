import Event from "./Event";

declare namespace openfl.events {

export class TimerEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any);
	clone():any;
	toString():any;
	updateAfterEvent():any;
	static TIMER:any;
	static TIMER_COMPLETE:any;


}

}

export default openfl.events.TimerEvent;