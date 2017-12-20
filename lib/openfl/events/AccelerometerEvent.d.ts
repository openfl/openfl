import Event from "./Event";

declare namespace openfl.events {

export class AccelerometerEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, timestamp?:any, accelerationX?:any, accelerationY?:any, accelerationZ?:any);
	accelerationX:any;
	accelerationY:any;
	accelerationZ:any;
	timestamp:any;
	clone():any;
	toString():any;
	static UPDATE:any;


}

}

export default openfl.events.AccelerometerEvent;