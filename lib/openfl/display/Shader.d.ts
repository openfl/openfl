import ShaderData from "./ShaderData";
import ShaderPrecision from "./ShaderPrecision";
import ByteArray from "./../utils/ByteArray";


declare namespace openfl.display {
	
	
	export class Shader {
		
		
		public readonly byteCode:ByteArray;
		
		public data:ShaderData;
		
		protected get_data ():ShaderData;
		protected set_data (value:ShaderData):ShaderData;
	
		public glFragmentSource:string;
		
		protected get_glFragmentSource ():string;
		protected set_glFragmentSource (value:string):string;
	
		public readonly glProgram:any;
		
		public glVertexSource:string;
		
		protected get_glVertexSource ():string;
		protected set_glVertexSource (value:string):string;
	
		public precisionHint:ShaderPrecision;
		
		public constructor (code?:ByteArray);
		
		
	}
	
	
}


export default openfl.display.Shader;