package openfl.errors; #if (!display && !flash)


class EOFError extends IOError {
	
	
	public function new () {
		
		super ("End of file was encountered");
		
		name = "EOFError";
		errorID = 2030;
		
	}
	
	
}


#else


/**
 * An EOFError exception is thrown when you attempt to read past the end of
 * the available data. For example, an EOFError is thrown when one of the read
 * methods in the IDataInput interface is called and there is insufficient
 * data to satisfy the read request.
 */

#if flash
@:native("flash.errors.EOFError")
#end

extern class EOFError extends IOError {
	
	
	/**
	 * Creates a new EOFError object.
	 * 
	 * @param message A string associated with the error object.
	 */
	public function new (?message:String, id:Int = 0):Void;
	
	
}


#end