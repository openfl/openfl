import Event from "./Event";

declare namespace openfl.events {

export class HTTPStatusEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, status?:any, redirected?:any);
	redirected:any;
	responseHeaders:any;
	responseURL:any;
	status:any;
	clone():any;
	toString():any;
	static HTTP_RESPONSE_STATUS:any;
	static HTTP_STATUS:any;


}

}

export default openfl.events.HTTPStatusEvent;