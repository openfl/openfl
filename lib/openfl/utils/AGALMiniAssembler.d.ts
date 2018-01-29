import ByteArray from "./ByteArray";
import Context3D from "./../display3D/Context3D";
import Program3D from "./../display3D/Program3D";


declare namespace openfl.utils {
	
	
	export class AGALMiniAssembler {
		
		
		public readonly agalcode:ByteArray;
		public readonly error:string;
		public verbose:boolean;
		
		public constructor (debugging?:boolean);
		
		public assemble2 (context3D:Context3D, version:number, vertexSource:string, fragmentSource:string):Program3D;
		public assemble (mode:string, source:string, version?:number, ignoreLimits?:boolean):ByteArray;
		
		
	}
	
	
}


export default openfl.utils.AGALMiniAssembler;