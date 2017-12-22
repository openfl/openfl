import Error from "./Error";


declare namespace openfl.errors {
	
	
	export class TypeError extends Error {
		
		
		public constructor (message?:string);
		
		
	}
	
	
}


export default openfl.errors.TypeError;