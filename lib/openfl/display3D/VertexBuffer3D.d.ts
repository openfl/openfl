import ByteArray from "./../utils/ByteArray";
import Vector from "./../Vector";


declare namespace openfl.display3D {
	
	
	export class VertexBuffer3D {
		
		
		public dispose ():void;
		public uploadFromByteArray (data:ByteArray, byteArrayOffset:number, startVertex:number, numVertices:number):void;
		public uploadFromTypedArray (data:ArrayBufferView):void;
		public uploadFromVector (data:Vector<number>, startVertex:number, numVertices:number):void;
		
		
	}
	
	
}


export default openfl.display3D.VertexBuffer3D;