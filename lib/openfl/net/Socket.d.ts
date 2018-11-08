import ObjectEncoding from "./ObjectEncoding";
import EventDispatcher from "./../events/EventDispatcher";
import ByteArray from "./../utils/ByteArray";
import Endian from "./../utils/Endian";
import IDataInput from "./../utils/IDataInput";
import IDataOutput from "./../utils/IDataOutput";


declare namespace openfl.net {
	
	
	export class Socket extends EventDispatcher implements IDataInput, IDataOutput {
		
		
		public readonly bytesAvailable:number;
		
		protected get_bytesAvailable ():number;
		
		public readonly bytesPending:number;
		
		protected get_bytesPending ():number;
		
		public readonly connected:boolean;
		
		protected get_connected ():boolean;
		
		public endian:Endian;
		
		protected get_endian ():Endian;
		protected set_endian (value:Endian):Endian;
		
		public objectEncoding:ObjectEncoding;
		public timeout:number;
		
		public constructor (host?:string, port?:number);
		public close ():void;
		public connect (host?:string, port?:number):void;
		public flush ():void;
		public readBoolean ():boolean;
		public readByte ():number;
		public readBytes (bytes:ByteArray, offset?:number, length?:number):void;
		public readDouble ():number;
		public readFloat ():number;
		public readInt ():number;
		public readMultiByte (length:number, charSet:string):string;
		
		// #if flash
		// @:noCompletion @:dox(hide) public readObject ():Dynamic;
		// #end
		
		public readShort ():number;
		public readUnsignedByte ():number;
		public readUnsignedInt ():number;
		public readUnsignedShort ():number;
		public readUTF ():string;
		public readUTFBytes (length:number):string;
		public writeBoolean (value:boolean):void;
		public writeByte (value:number):void;
		public writeBytes (bytes:ByteArray, offset?:number, length?:number):void;
		public writeDouble (value:number):void;
		public writeFloat (value:number):void;
		public writeInt (value:number):void;
		public writeMultiByte (value:string, charSet:string):void;
		
		// #if flash
		// @:noCompletion @:dox(hide) public writeObject (object:Dynamic):void;
		// #end
		
		public writeShort (value:number):void;
		public writeUnsignedInt (value:number):void;
		public writeUTF (value:string):void;
		public writeUTFBytes (value:string):void;
		
		
	}
	
	
}


export default openfl.net.Socket;