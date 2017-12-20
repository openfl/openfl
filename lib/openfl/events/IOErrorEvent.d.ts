import ErrorEvent from "./ErrorEvent";

declare namespace openfl.events {

export class IOErrorEvent extends ErrorEvent {

	constructor(type:any, bubbles?:any, cancelable?:any, text?:any, id?:any);
	clone():any;
	toString():any;
	static IO_ERROR:any;


}

}

export default openfl.events.IOErrorEvent;