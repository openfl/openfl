import Stage from "./Stage";

type WindowConfig = any;


declare namespace openfl.display {
	
	
	export class Window {
		
		
		stage:Stage;
		
		constructor (config?:WindowConfig);
		
		
	}
	
	
}


export default openfl.display.Window;