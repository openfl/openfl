import Event from "./Event";

declare namespace openfl.events {

export class KeyboardEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, charCodeValue?:any, keyCodeValue?:any, keyLocationValue?:any, ctrlKeyValue?:any, altKeyValue?:any, shiftKeyValue?:any, controlKeyValue?:any, commandKeyValue?:any);
	altKey:any;
	charCode:any;
	ctrlKey:any;
	commandKey:any;
	controlKey:any;
	keyCode:any;
	keyLocation:any;
	shiftKey:any;
	clone():any;
	toString():any;
	static KEY_DOWN:any;
	static KEY_UP:any;


}

}

export default openfl.events.KeyboardEvent;