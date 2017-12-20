import Event from "./Event";

declare namespace openfl.events {

export class ProgressEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, bytesLoaded?:any, bytesTotal?:any);
	bytesLoaded:any;
	bytesTotal:any;
	clone():any;
	toString():any;
	static PROGRESS:any;
	static SOCKET_DATA:any;


}

}

export default openfl.events.ProgressEvent;