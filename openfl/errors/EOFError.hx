package openfl.errors; #if !flash


/**
 * An EOFError exception is thrown when you attempt to read past the end of
 * the available data. For example, an EOFError is thrown when one of the read
 * methods in the IDataInput interface is called and there is insufficient
 * data to satisfy the read request.
 */
class EOFError extends Error {
	
	
	/**
	 * Creates a new EOFError object.
	 * 
	 * @param message A string associated with the error object.
	 */
	public function new () {
		
		super ("End of file was encountered", 2030);
		
	}
	
	
}


#else
typedef EOFError = flash.errors.EOFError;
#end