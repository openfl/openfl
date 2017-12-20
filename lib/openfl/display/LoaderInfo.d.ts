import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.display {

export class LoaderInfo extends EventDispatcher {

	constructor();
	applicationDomain:any;
	bytes:any;
	bytesLoaded:any;
	bytesTotal:any;
	childAllowsParent:any;
	content:any;
	contentType:any;
	frameRate:any;
	height:any;
	loader:any;
	loaderURL:any;
	
	parentAllowsChild:any;
	sameDomain:any;
	sharedEvents:any;
	uncaughtErrorEvents:any;
	url:any;
	width:any;
	__completed:any;
	__complete():any;
	__update(bytesLoaded:any, bytesTotal:any):any;
	static __rootURL:any;
	static create(loader:any):any;


}

}

export default openfl.display.LoaderInfo;