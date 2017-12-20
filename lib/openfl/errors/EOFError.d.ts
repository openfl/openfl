import IOError from "./IOError";

declare namespace openfl.errors {

export class EOFError extends IOError {

	constructor();


}

}

export default openfl.errors.EOFError;