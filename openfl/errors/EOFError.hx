/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.errors;
#if display


/**
 * An EOFError exception is thrown when you attempt to read past the end of
 * the available data. For example, an EOFError is thrown when one of the read
 * methods in the IDataInput interface is called and there is insufficient
 * data to satisfy the read request.
 */
extern class EOFError/* extends IOError*/ {

	/**
	 * Creates a new EOFError object.
	 * 
	 * @param message A string associated with the error object.
	 */
	function new(?message : String, id : Int = 0) : Void;
}


#end
