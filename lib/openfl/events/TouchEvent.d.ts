import Event from "./Event";

declare namespace openfl.events {

export class TouchEvent extends Event {

	constructor(type:any, bubbles?:any, cancelable?:any, touchPointID?:any, isPrimaryTouchPoint?:any, localX?:any, localY?:any, sizeX?:any, sizeY?:any, pressure?:any, relatedObject?:any, ctrlKey?:any, altKey?:any, shiftKey?:any, commandKey?:any, controlKey?:any, timestamp?:any, touchIntent?:any, samples?:any, isTouchPointCanceled?:any);
	altKey:any;
	commandKey:any;
	controlKey:any;
	ctrlKey:any;
	delta:any;
	isPrimaryTouchPoint:any;
	localX:any;
	localY:any;
	pressure:any;
	relatedObject:any;
	shiftKey:any;
	sizeX:any;
	sizeY:any;
	stageX:any;
	stageY:any;
	touchPointID:any;
	clone():any;
	toString():any;
	updateAfterEvent():any;
	static TOUCH_BEGIN:any;
	static TOUCH_END:any;
	static TOUCH_MOVE:any;
	static TOUCH_OUT:any;
	static TOUCH_OVER:any;
	static TOUCH_ROLL_OUT:any;
	static TOUCH_ROLL_OVER:any;
	static TOUCH_TAP:any;
	static __create(type:any, touch:any, stageX:any, stageY:any, local:any, target:any):any;


}

}

export default openfl.events.TouchEvent;