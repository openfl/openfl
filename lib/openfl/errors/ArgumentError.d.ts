import Error from "./Error";


declare namespace openfl.errors {
	
	
	export class ArgumentError extends Error {
		
		
		public constructor (message?:String);
		
		
	}
	
	
}


export default openfl.errors.ArgumentError;