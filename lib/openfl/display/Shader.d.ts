import ShaderData from "./ShaderData";
import ShaderPrecision from "./ShaderPrecision";
import ByteArray from "./../utils/ByteArray";


declare namespace openfl.display {
	
	
	export class Shader {
		
		
		public readonly byteCode:ByteArray;
		public data:ShaderData;
		public glFragmentSource:string;
		public readonly glProgram:any;
		public glVertexSource:string;
		public precisionHint:ShaderPrecision;
		
		public constructor (code?:ByteArray);
		
		
	}
	
	
}


export default openfl.display.Shader;