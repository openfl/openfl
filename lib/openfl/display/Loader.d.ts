import DisplayObjectContainer from "./DisplayObjectContainer";

declare namespace openfl.display {

export class Loader extends DisplayObjectContainer {

	constructor();
	content:any;
	contentLoaderInfo:any;
	uncaughtErrorEvents:any;
	__library:any;
	__path:any;
	__unloaded:any;
	close():any;
	load(request:any, context?:any):any;
	loadBytes(buffer:any, context?:any):any;
	unload():any;
	unloadAndStop(gc?:any):any;
	__dispatchError(text:any):any;
	BitmapData_onError(error:any):any;
	BitmapData_onLoad(bitmapData:any):any;
	BitmapData_onProgress(bytesLoaded:any, bytesTotal:any):any;
	loader_onComplete(event:any):any;
	loader_onError(event:any):any;
	loader_onProgress(event:any):any;


}

}

export default openfl.display.Loader;