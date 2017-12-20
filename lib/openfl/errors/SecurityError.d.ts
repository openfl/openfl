import Error from "./Error";

declare namespace openfl.errors {

export class SecurityError extends Error {

	constructor(message?:any);


}

}

export default openfl.errors.SecurityError;