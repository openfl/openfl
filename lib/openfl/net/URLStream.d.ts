import EventDispatcher from "./../events/EventDispatcher";
import URLRequest from "./../net/URLRequest";
import ByteArray from "./../utils/ByteArray";
import Endian from "./../utils/Endian";
import IDataInput from "./../utils/IDataInput";


declare namespace openfl.net {
	
	
	export class URLStream extends EventDispatcher implements IDataInput {
		
		
		public readonly bytesAvailable:number;
		public readonly connected:boolean;
		//@:require(flash11_4) public var diskCacheEnabled (default, null):boolean;
		public endian:Endian;
		//@:require(flash11_4) public var length (default, null):Float;
		public objectEncoding:number;
		//@:require(flash11_4) public var position:Float;
		
		public constructor ();
		public close ():void;
		public load (request:URLRequest):void;
		public readBoolean ():boolean;
		public readByte ():number;
		public readBytes (bytes:ByteArray, offset?:number, length?:number):void;
		public readDouble ():number;
		public readFloat ():number;
		public readInt ():number;
		public readMultiByte (length:number, charSet:string):string;
		public readObject ():any;
		public readShort ():number;
		public readUTF ():string;
		public readUTFBytes (length:number):string;
		public readUnsignedByte ():number;
		public readUnsignedInt ():number;
		public readUnsignedShort ():number;
		//@:require(flash11_4) public stop ():Void;
		
		// @:noCompletion @:dox(hide) private get_bytesAvailable ():UInt;
		// @:noCompletion @:dox(hide) private get_endian ():Endian;
		// @:noCompletion @:dox(hide) private set_endian (value:Endian):Endian;
		
	}
	
	
}


export default openfl.net.URLStream;