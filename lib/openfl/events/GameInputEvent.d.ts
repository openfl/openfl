import Event from "./Event";

declare namespace openfl.events {

export class GameInputEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, device?:any);
	device:any;
	clone():any;
	toString():any;
	static DEVICE_ADDED:any;
	static DEVICE_REMOVED:any;
	static DEVICE_UNUSABLE:any;


}

}

export default openfl.events.GameInputEvent;