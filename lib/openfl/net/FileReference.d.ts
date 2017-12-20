import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.net {

export class FileReference extends EventDispatcher {

	constructor();
	creationDate:any;
	creator:any;
	data:any;
	modificationDate:any;
	name:any;
	size:any;
	type:any;
	__data:any;
	__path:any;
	__urlLoader:any;
	browse(typeFilter?:any):any;
	cancel():any;
	download(request:any, defaultFileName?:any):any;
	load():any;
	save(data:any, defaultFileName?:any):any;
	upload(request:any, uploadDataFieldName?:any, testUpload?:any):any;
	openFileDialog_onCancel():any;
	openFileDialog_onComplete():any;
	openFileDialog_onSelect(path:any):any;
	saveFileDialog_onCancel():any;
	saveFileDialog_onSelect(path:any):any;
	urlLoader_onComplete(event:any):any;
	urlLoader_onIOError(event:any):any;
	urlLoader_onProgress(event:any):any;


}

}

export default openfl.net.FileReference;