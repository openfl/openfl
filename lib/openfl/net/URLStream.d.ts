import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.net {

export class URLStream extends EventDispatcher {

	constructor();
	bytesAvailable:any;
	connected:any;
	endian:any;
	objectEncoding:any;
	__data:any;
	__loader:any;
	close():any;
	load(request:any):any;
	readBoolean():any;
	readByte():any;
	readBytes(bytes:any, offset?:any, length?:any):any;
	readDouble():any;
	readFloat():any;
	readInt():any;
	readMultiByte(length:any, charSet:any):any;
	readObject():any;
	readShort():any;
	readUnsignedByte():any;
	readUnsignedInt():any;
	readUnsignedShort():any;
	readUTF():any;
	readUTFBytes(length:any):any;
	__addEventListeners():any;
	__removeEventListeners():any;
	loader_onComplete(event:any):any;
	loader_onIOError(event:any):any;
	loader_onSecurityError(event:any):any;
	loader_onProgressEvent(event:any):any;
	get_bytesAvailable():any;
	get_connected():any;
	get_endian():any;
	set_endian(value:any):any;


}

}

export default openfl.net.URLStream;