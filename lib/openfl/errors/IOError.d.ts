import Error from "./Error";

declare namespace openfl.errors {

export class IOError extends Error {

	constructor(message?:any);


}

}

export default openfl.errors.IOError;