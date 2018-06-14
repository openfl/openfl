package openfl.errors {
	
	
	/**
	 * @externs
	 * An EOFError exception is thrown when you attempt to read past the end of
	 * the available data. For example, an EOFError is thrown when one of the read
	 * methods in the IDataInput interface is called and there is insufficient
	 * data to satisfy the read request.
	 */
	public class EOFError extends IOError {
		
		
		/**
		 * Creates a new EOFError object.
		 * 
		 * @param message A string associated with the error object.
		 */
		public function EOFError (message:String = null, id:int = 0) {}
		
		
	}
	
	
}