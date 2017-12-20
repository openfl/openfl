
declare namespace openfl.events {

export class Event {

	constructor(type:any, bubbles?:any, cancelable?:any);
	bubbles:any;
	cancelable:any;
	currentTarget:any;
	eventPhase:any;
	target:any;
	type:any;
	__isCanceled:any;
	__isCanceledNow:any;
	__preventDefault:any;
	clone():any;
	formatToString(className:any, p1?:any, p2?:any, p3?:any, p4?:any, p5?:any):any;
	isDefaultPrevented():any;
	preventDefault():any;
	stopImmediatePropagation():any;
	stopPropagation():any;
	toString():any;
	__formatToString(className:any, parameters:any):any;
	static ACTIVATE:any;
	static ADDED:any;
	static ADDED_TO_STAGE:any;
	static CANCEL:any;
	static CHANGE:any;
	static CLEAR:any;
	static CLOSE:any;
	static COMPLETE:any;
	static CONNECT:any;
	static CONTEXT3D_CREATE:any;
	static COPY:any;
	static CUT:any;
	static DEACTIVATE:any;
	static ENTER_FRAME:any;
	static EXIT_FRAME:any;
	static FRAME_CONSTRUCTED:any;
	static FRAME_LABEL:any;
	static FULLSCREEN:any;
	static ID3:any;
	static INIT:any;
	static MOUSE_LEAVE:any;
	static OPEN:any;
	static PASTE:any;
	static REMOVED:any;
	static REMOVED_FROM_STAGE:any;
	static RENDER:any;
	static RESIZE:any;
	static SCROLL:any;
	static SELECT:any;
	static SELECT_ALL:any;
	static SOUND_COMPLETE:any;
	static TAB_CHILDREN_CHANGE:any;
	static TAB_ENABLED_CHANGE:any;
	static TAB_INDEX_CHANGE:any;
	static TEXTURE_READY:any;
	static UNLOAD:any;


}

}

export default openfl.events.Event;