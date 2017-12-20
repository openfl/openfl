
declare namespace openfl.errors {

export class Error {

	constructor(message?:any, id?:any);
	errorID:any;
	message:any;
	name:any;
	getStackTrace():any;
	toString():any;
	static DEFAULT_TO_STRING:any;


}

}

export default openfl.errors.Error;