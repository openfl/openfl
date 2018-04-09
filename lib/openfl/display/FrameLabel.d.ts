import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.display {
	
	
	/*@:final*/ export class FrameLabel extends EventDispatcher {
		
		
		public readonly frame:number;
		
		private get_frame ():number;
		
		public readonly name:string;
		
		private get_name ():string;
		
		
		public constructor (name:string, frame:number);
		
		
	}
	
	
}


export default openfl.display.FrameLabel;