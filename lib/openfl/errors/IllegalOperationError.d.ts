import Error from "./Error";

declare namespace openfl.errors {

export class IllegalOperationError extends Error {

	constructor(message?:any);


}

}

export default openfl.errors.IllegalOperationError;