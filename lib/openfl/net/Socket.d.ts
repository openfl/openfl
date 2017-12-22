import EventDispatcher from "./../events/EventDispatcher";
import ByteArray from "./../utils/ByteArray";
import Endian from "./../utils/Endian";
import IDataInput from "./../utils/IDataInput";
import IDataOutput from "./../utils/IDataOutput";


declare namespace openfl.net {
	
	
	export class Socket extends EventDispatcher implements IDataInput, IDataOutput {
		
		
		public readonly bytesAvailable:number;
		public readonly bytesPending:number;
		public readonly connected:boolean;
		public endian:Endian;
		public objectEncoding:number;
		public timeout:number;
		
		// @:noCompletion private get_bytesAvailable ():number;
		// @:noCompletion private get_endian ():Endian;
		// @:noCompletion private set_endian (value:Endian):Endian;
		
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