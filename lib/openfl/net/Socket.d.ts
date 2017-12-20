import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.net {

export class Socket extends EventDispatcher {

	constructor(host?:any, port?:any);
	bytesAvailable:any;
	bytesPending:any;
	connected:any;
	objectEncoding:any;
	secure:any;
	timeout:any;
	endian:any;
	__buffer:any;
	__connected:any;
	__endian:any;
	__host:any;
	__input:any;
	__inputBuffer:any;
	__output:any;
	__port:any;
	
	__timestamp:any;
	connect(host?:any, port?:any):any;
	close():any;
	flush():any;
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
	writeBoolean(value:any):any;
	writeByte(value:any):any;
	writeBytes(bytes:any, offset?:any, length?:any):any;
	writeDouble(value:any):any;
	writeFloat(value:any):any;
	writeInt(value:any):any;
	writeMultiByte(value:any, charSet:any):any;
	writeShort(value:any):any;
	writeUnsignedInt(value:any):any;
	writeUTF(value:any):any;
	writeUTFBytes(value:any):any;
	__cleanSocket():any;
	socket_onClose(_:any):any;
	socket_onError(e:any):any;
	socket_onMessage(msg:any):any;
	socket_onOpen(_:any):any;
	this_onEnterFrame(event:any):any;
	get_bytesAvailable():any;
	get_bytesPending():any;
	get_connected():any;
	get_endian():any;
	set_endian(value:any):any;


}

}

export default openfl.net.Socket;