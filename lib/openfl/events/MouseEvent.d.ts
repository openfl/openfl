import Event from "./Event";

declare namespace openfl.events {

export class MouseEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, localX?:any, localY?:any, relatedObject?:any, ctrlKey?:any, altKey?:any, shiftKey?:any, buttonDown?:any, delta?:any, commandKey?:any, clickCount?:any);
	altKey:any;
	buttonDown:any;
	commandKey:any;
	clickCount:any;
	ctrlKey:any;
	delta:any;
	isRelatedObjectInaccessible:any;
	localX:any;
	localY:any;
	relatedObject:any;
	shiftKey:any;
	stageX:any;
	stageY:any;
	clone():any;
	toString():any;
	updateAfterEvent():any;
	static CLICK:any;
	static DOUBLE_CLICK:any;
	static MIDDLE_CLICK:any;
	static MIDDLE_MOUSE_DOWN:any;
	static MIDDLE_MOUSE_UP:any;
	static MOUSE_DOWN:any;
	static MOUSE_MOVE:any;
	static MOUSE_OUT:any;
	static MOUSE_OVER:any;
	static MOUSE_UP:any;
	static MOUSE_WHEEL:any;
	static RELEASE_OUTSIDE:any;
	static RIGHT_CLICK:any;
	static RIGHT_MOUSE_DOWN:any;
	static RIGHT_MOUSE_UP:any;
	static ROLL_OUT:any;
	static ROLL_OVER:any;
	static __altKey:any;
	static __buttonDown:any;
	static __commandKey:any;
	static __ctrlKey:any;
	static __shiftKey:any;
	static __create(type:any, button:any, stageX:any, stageY:any, local:any, target:any, delta?:any):any;


}

}

export default openfl.events.MouseEvent;