import ByteArray from "./../utils/ByteArray";


declare namespace openfl.display3D {
	
	
	/*@:final*/ export class Program3D {
		
		
		public dispose ():void;
		public upload (vertexProgram:ByteArray, fragmentProgram:ByteArray):void;
		
		
	}
	
	
}


export default openfl.display3D.Program3D;