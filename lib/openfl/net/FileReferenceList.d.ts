import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.net {

export class FileReferenceList extends EventDispatcher {

	constructor();
	fileList:any;
	browse(typeFilter?:any):any;
	fileDialog_onCancel():any;
	fileDialog_onSelectMultiple(paths:any):any;


}

}

export default openfl.net.FileReferenceList;