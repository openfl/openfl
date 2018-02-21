import Event from "./Event";


declare namespace openfl.events {
	
	
	export class ActivityEvent extends Event {
		
		
		public static ACTIVITY:string;
		
		public activating:boolean;
		
		
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean, activating?:boolean);
		
		
	}
	
	
}


export default openfl.events.ActivityEvent;