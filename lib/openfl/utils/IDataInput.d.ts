declare namespace openfl.utils {
	
	
	export class IDataInput {

		
		// get_bytesAvailable():any;
		// get_endian():any;
		// set_endian(value:any):any;
		bytesAvailable:any;
		endian:any;
		objectEncoding:any;
		readBoolean():any;
		readByte():any;
		readBytes(bytes:any, offset?:any, length?:any):any;
		readDouble():any;
		readFloat():any;
		readInt():any;
		readMultiByte(length:any, charSet:any):any;
		readShort():any;
		readUnsignedByte():any;
		readUnsignedInt():any;
		readUnsignedShort():any;
		readUTF():any;
		readUTFBytes(length:any):any;
		
		
	}
	
	
}


export default openfl.utils.IDataInput;