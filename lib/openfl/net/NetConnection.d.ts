import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.net {

export class NetConnection extends EventDispatcher {

	constructor();
	connect(command:any, _?:any, _?:any, _?:any, _?:any, _?:any):any;
	static CONNECT_SUCCESS:any;


}

}

export default openfl.net.NetConnection;