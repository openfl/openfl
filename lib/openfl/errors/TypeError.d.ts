import Error from "./Error";

declare namespace openfl.errors {

export class TypeError extends Error {

	constructor(message?:any);


}

}

export default openfl.errors.TypeError;