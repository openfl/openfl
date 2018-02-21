import Shader from "./Shader";
import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.display {
	
	
	export class ShaderJob extends EventDispatcher {
		
		
		width:number;
		height:number;
		readonly progress:number;
		shader:Shader;
		target:any;
		
		
		constructor (shader?:Shader, target?:any, width?:number, height?:number);
		cancel ():void;
		start (waitForCompletion?:boolean):void;
		
		
	}
	
	
}


export default openfl.display.ShaderJob;