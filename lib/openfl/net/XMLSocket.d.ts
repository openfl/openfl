import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.net {

export class XMLSocket extends EventDispatcher {

	constructor(host?:any, port?:any);
	connected:any;
	timeout:any;
	__socket:any;
	close():any;
	connect(host:any, port:any):any;
	send(object:any):any;
	__onClose(_:any):any;
	__onConnect(_:any):any;
	__onError(_:any):any;
	__onSocketData(_:any):any;


}

}

export default openfl.net.XMLSocket;