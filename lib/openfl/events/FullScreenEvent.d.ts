import ActivityEvent from "./ActivityEvent";


declare namespace openfl.events {
	
	
	export class FullScreenEvent extends ActivityEvent {
	
	
		public static FULL_SCREEN:string;
		public static FULL_SCREEN_INTERACTIVE_ACCEPTED:string;
		
		public fullScreen:boolean;
		public interactive:boolean;
		
		
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean, fullScreen?:boolean, interactive?:boolean);
		
		
	}
	
	
}


export default openfl.events.FullScreenEvent;