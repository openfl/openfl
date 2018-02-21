import ErrorEvent from "./ErrorEvent";


declare namespace openfl.events {
	
	
	export class UncaughtErrorEvent extends ErrorEvent {
		
		
		static UNCAUGHT_ERROR;
		
		readonly error:any;
		
		
		constructor (type:string, bubbles?:boolean, cancelable?:boolean, error?:any);
		
		
	}
	
	
}


export default openfl.events.UncaughtErrorEvent;