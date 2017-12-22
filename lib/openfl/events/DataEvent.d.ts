import TextEvent from "./TextEvent";


declare namespace openfl.events {
	
	
	export class DataEvent extends TextEvent {
	
	
		public static DATA:string;
		public static UPLOAD_COMPLETE_DATA:string;
		
		public data:string;
		
		
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean, data?:string);
		
		
	}
	
	
}


export default openfl.events.DataEvent;