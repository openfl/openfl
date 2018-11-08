import Error from "./../errors/Error";
import ErrorEvent from "./ErrorEvent";


declare namespace openfl.events {
	
	
	export class AsyncErrorEvent extends ErrorEvent {
		
		
		static ASYNC_ERROR;
		
		error:Error;
		
		
		constructor (type:string, bubbles?:boolean, cancelable?:boolean, text?:string, error?:Error);
		
		
	}
	
	
}


export default openfl.events.AsyncErrorEvent;