

declare namespace openfl.events {

export class IEventDispatcher {

	
	addEventListener(type:any, listener:any, useCapture?:any, priority?:any, useWeakReference?:any):any;
	dispatchEvent(event:any):any;
	hasEventListener(type:any):any;
	removeEventListener(type:any, listener:any, useCapture?:any):any;
	willTrigger(type:any):any;


}

}

export default openfl.events.IEventDispatcher;