import ByteArray from "./ByteArray";
import Endian from "./Endian";


declare namespace openfl.utils {
	
	
	export class IDataOutput {
		
		
		public endian:Endian;
		
		// protected get_endian ():Endian;
		// protected set_endian (value:Endian):Endian;
		
		public objectEncoding:number;
		
		public writeBoolean (value:boolean):void;
		public writeByte (value:number):void;
		public writeBytes (bytes:ByteArray, offset?:number, length?:number):void;
		public writeDouble (value:number):void;
		public writeFloat (value:number):void;
		public writeInt (value:number):void;
		public writeMultiByte (value:string, charSet:string):void;
		
		// #if (flash && !display)
		// public writeObject (object:Dynamic):void;
		// #end
		
		public writeShort (value:number):void;
		public writeUTF (value:string):void;
		public writeUTFBytes (value:string):void;
		public writeUnsignedInt (value:number):void;
		
	}
	
	
}


export default openfl.utils.IDataOutput;