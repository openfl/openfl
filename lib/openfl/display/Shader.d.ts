import ShaderData from "./ShaderData";
import ShaderPrecision from "./ShaderPrecision";
import ByteArray from "./../utils/ByteArray";


declare namespace openfl.display {
	
	
	export class Shader {
		
		
		public readonly byteCode:ByteArray;
		
		public data:ShaderData;
		
		private get_data ():ShaderData;
		private set_data (value:ShaderData):ShaderData;
	
		public glFragmentSource:string;
		
		private get_glFragmentSource ():string;
		private set_glFragmentSource (value:string):string;
	
		public readonly glProgram:any;
		
		public glVertexSource:string;
		
		private get_glVertexSource ():string;
		private set_glVertexSource (value:string):string;
	
		public precisionHint:ShaderPrecision;
		
		public constructor (code?:ByteArray);
		
		
	}
	
	
}


export default openfl.display.Shader;