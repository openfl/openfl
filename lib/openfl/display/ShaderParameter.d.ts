import ShaderParameterType from "./ShaderParameterType";


declare namespace openfl.display {
	
	
	/*@:final*/ export class ShaderParameter<T> /*implements Dynamic*/ {
		
		
		readonly index:number;
		readonly type:ShaderParameterType;
		value:Array<T>;
		
		constructor ();
		
		
	}
	
	
}


export default openfl.display.ShaderParameter;