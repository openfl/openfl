import Event from "./Event";


declare namespace openfl.events {
	
	
	export class IEventDispatcher {
	
		public addEventListener (type:string, listener:(event:any) => void, useCapture?:boolean, priority?:number, useWeakReference?:boolean):void;
		public dispatchEvent (event:Event):boolean;
		public hasEventListener (type:string):boolean;
		public removeEventListener (type:string, listener:(event:any) => void, useCapture?:boolean):void;
		public willTrigger (type:string):boolean;
		
	}
	
	
}


export default openfl.events.IEventDispatcher;