import ByteArray from "./../utils/ByteArray";
import Shader from "./Shader";


declare namespace openfl.display {
	
	
	export class DisplayObjectShader extends Shader {
		
		
		public constructor (code?:ByteArray);
		
		
	}
	
	
}


export default openfl.display.DisplayObjectShader;