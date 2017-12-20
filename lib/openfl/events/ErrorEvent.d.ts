import TextEvent from "./TextEvent";

declare namespace openfl.events {

export class ErrorEvent extends TextEvent {

	constructor(type:any, bubbles?:any, cancelable?:any, text?:any, id?:any);
	errorID:any;
	clone():any;
	toString():any;
	static ERROR:any;


}

}

export default openfl.events.ErrorEvent;