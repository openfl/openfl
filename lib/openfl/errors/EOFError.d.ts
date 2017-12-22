import IOError from "./IOError";


declare namespace openfl.errors {
	
	
	/**
	 * An EOFError exception is thrown when you attempt to read past the end of
	 * the available data. For example, an EOFError is thrown when one of the read
	 * methods in the IDataInput interface is called and there is insufficient
	 * data to satisfy the read request.
	 */
	export class EOFError extends IOError {
		
		
		/**
		 * Creates a new EOFError object.
		 * 
		 * @param message A string associated with the error object.
		 */
		public constructor (message?:string, id?:number);
		
		
	}
	
	
}


export default openfl.errors.EOFError;