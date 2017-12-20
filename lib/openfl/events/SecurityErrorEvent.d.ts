import ErrorEvent from "./ErrorEvent";

declare namespace openfl.events {

export class SecurityErrorEvent extends ErrorEvent {

	constructor(type:any, bubbles?:any, cancelable?:any, text?:any, id?:any);
	clone():any;
	toString():any;
	static SECURITY_ERROR:any;


}

}

export default openfl.events.SecurityErrorEvent;