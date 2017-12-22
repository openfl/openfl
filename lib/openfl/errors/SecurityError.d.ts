import Error from "./Error";


declare namespace openfl.errors {
	
	
	export class SecurityError extends Error {
		
		
		public constructor (message?:string);
		
		
	}
	
	
}


export default openfl.errors.SecurityError;