import ByteArray from "./ByteArray";
import Endian from "./Endian";


declare namespace openfl.utils {
	
	
	export class IDataInput {
		
		
		public readonly bytesAvailable:number;
		public endian:Endian;
		public objectEncoding:number;
		
		public readBoolean ():boolean;
		public readByte ():number;
		public readBytes (bytes:ByteArray, offset?:number, length?:number):void;
		public readDouble ():number;
		public readFloat ():number;
		public readInt ():number;
		public readMultiByte (length:number, charSet:string):string;
		
		// #if (flash && !display)
		// public readObject ():Dynamic;
		// #end
		
		public readShort ():number;
		public readUnsignedByte ():number;
		public readUnsignedInt ():number;
		public readUnsignedShort ():number;
		public readUTF ():string;
		public readUTFBytes (length:number):string;
		
		
	}
	
	
}


export default openfl.utils.IDataInput;