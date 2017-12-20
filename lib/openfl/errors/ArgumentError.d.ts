import Error from "./Error";

declare namespace openfl.errors {

export class ArgumentError extends Error {

	constructor(message?:any);


}

}

export default openfl.errors.ArgumentError;