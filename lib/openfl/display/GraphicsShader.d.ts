import BitmapData from "./../display/BitmapData";
import ShaderInput from "./../display/ShaderInput";
import ByteArray from "./../utils/ByteArray";
import Shader from "./Shader";


declare namespace openfl.display {
	
	
	export class GraphicsShader extends Shader {
		
		
		public bitmap:ShaderInput<BitmapData>;
		
		public constructor (code?:ByteArray);
		
		
	}
	
	
}


export default openfl.display.GraphicsShader;