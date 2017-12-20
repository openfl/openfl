import Error from "./Error";

declare namespace openfl.errors {

export class RangeError extends Error {

	constructor(message?:any);


}

}

export default openfl.errors.RangeError;