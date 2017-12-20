import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.net {

export class SharedObject extends EventDispatcher {

	constructor();
	
	
	fps:any;
	objectEncoding:any;
	size:any;
	__localPath:any;
	__name:any;
	clear():any;
	close():any;
	connect(myConnection:any, params?:any):any;
	flush(minDiskSpace?:any):any;
	send(args:any):any;
	setDirty(propertyName:any):any;
	setProperty(propertyName:any, value?:any):any;
	get_size():any;
	static defaultObjectEncoding:any;
	static __sharedObjects:any;
	static getLocal(name:any, localPath?:any, secure?:any):any;
	static getRemote(name:any, remotePath?:any, persistence?:any, secure?:any):any;
	static __getPath(localPath:any, name:any):any;
	static __mkdir(directory:any):any;
	static __resolveClass(name:any):any;
	static application_onExit(_:any):any;


}

}

export default openfl.net.SharedObject;