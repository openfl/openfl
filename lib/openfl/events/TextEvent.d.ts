import Event from "./Event";

declare namespace openfl.events {

export class TextEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, text?:any);
	text:any;
	clone():any;
	toString():any;
	static LINK:any;
	static TEXT_INPUT:any;


}

}

export default openfl.events.TextEvent;