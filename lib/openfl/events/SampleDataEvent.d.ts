import Event from "./Event";
import ByteArray from "./../utils/ByteArray";


declare namespace openfl.events {
	
	
	export class SampleDataEvent extends Event {
		
		
		public static SAMPLE_DATA:string;
		
		public data:ByteArray;
		public position:number;
		
		
		public constructor (type:string, bubbles?:boolean, cancelable?:boolean);
		
		
	}
	
	
}


export default openfl.events.SampleDataEvent;