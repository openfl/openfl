import Event from "./Event";


declare namespace openfl.events {
	
	
	export class NetStatusEvent extends Event {
		
		
		static NET_STATUS;
		
		info:any;
		
		
		constructor (type:string, bubbles?:boolean, cancelable?:boolean, info?:any);
		
		
	}
	
	
}


export default openfl.events.NetStatusEvent;