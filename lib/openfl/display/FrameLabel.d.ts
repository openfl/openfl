import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.display {
	
	
	/*@:final*/ export class FrameLabel extends EventDispatcher {
		
		
		public readonly frame:number;
		public readonly name:string;
		
		public constructor (name:string, frame:number);
		
		
	}
	
	
}


export default openfl.display.FrameLabel;