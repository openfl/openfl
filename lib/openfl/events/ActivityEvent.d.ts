import Event from "./Event";

declare namespace openfl.events {

export class ActivityEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, activating?:any);
	activating:any;
	clone():any;
	toString():any;
	static ACTIVITY:any;


}

}

export default openfl.events.ActivityEvent;