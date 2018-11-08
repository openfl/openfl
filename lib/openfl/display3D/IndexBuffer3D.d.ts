import ByteArray from "./../utils/ByteArray";
import Vector from "./../Vector";


declare namespace openfl.display3D {
	
	
	/*@:final*/ export class IndexBuffer3D {
		
		
		public dispose ():void;
		public uploadFromByteArray (data:ByteArray, byteArrayOffset:number, startOffset:number, count:number):void;
		public uploadFromTypedArray (data:ArrayBufferView):void;
		public uploadFromVector (data:Vector<number>, startOffset:number, count:number):void;
		
		
	}
	
	
}


export default openfl.display3D.IndexBuffer3D;