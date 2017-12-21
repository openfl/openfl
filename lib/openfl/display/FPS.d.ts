import TextField from "./../text/TextField";

declare namespace openfl.display {
	
	
	export class FPS extends TextField {
		
		
		public readonly currentFPS:number;
		
		public constructor (x?:number, y?:number, color?:number);
		
		
	}
	
	
}


export default openfl.display.FPS;