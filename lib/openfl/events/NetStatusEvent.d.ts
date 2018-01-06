import Event from "./Event";


declare namespace openfl.events {
	
	
	export class NetStatusEvent extends Event {
		
		
		static NET_STATUS;
		
		info:object;
		
		
		constructor (type:string, bubbles?:boolean, cancelable?:boolean, info?:object);
		
		
	}
	
	
}


export default openfl.events.NetStatusEvent;