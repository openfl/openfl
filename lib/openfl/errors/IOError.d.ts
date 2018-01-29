import Error from "./Error";


declare namespace openfl.errors {
	
	
	export class IOError extends Error {
		
		
		public constructor (message?:string);
		
		
	}
	
	
}


export default openfl.errors.IOError;