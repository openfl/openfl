

declare namespace openfl.utils {

export class IDataOutput {

	
	// get_endian():any;
	// set_endian(value:any):any;
	endian:any;
	objectEncoding:any;
	writeBoolean(value:any):any;
	writeByte(value:any):any;
	writeBytes(bytes:any, offset?:any, length?:any):any;
	writeDouble(value:any):any;
	writeFloat(value:any):any;
	writeInt(value:any):any;
	writeMultiByte(value:any, charSet:any):any;
	writeShort(value:any):any;
	writeUTF(value:any):any;
	writeUTFBytes(value:any):any;
	writeUnsignedInt(value:any):any;


}

}

export default openfl.utils.IDataOutput;