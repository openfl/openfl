import Error from "./Error";


declare namespace openfl.errors {
	
	
	export class RangeError extends Error {
		
		
		public constructor (message?:string);
		
		
	}
	
	
}


export default openfl.errors.RangeError;