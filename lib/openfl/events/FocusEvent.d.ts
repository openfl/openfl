import Event from "./Event";

declare namespace openfl.events {

export class FocusEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, relatedObject?:any, shiftKey?:any, keyCode?:any);
	keyCode:any;
	relatedObject:any;
	shiftKey:any;
	clone():any;
	toString():any;
	static FOCUS_IN:any;
	static FOCUS_OUT:any;
	static KEY_FOCUS_CHANGE:any;
	static MOUSE_FOCUS_CHANGE:any;


}

}

export default openfl.events.FocusEvent;