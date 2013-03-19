package flash.net;
#if (flash || display)


/**
 * The SharedObjectFlushStatus class provides values for the code returned
 * from a call to the <code>SharedObject.flush()</code> method.
 */
extern class SharedObjectFlushStatus {
	function new() : Void;

	/**
	 * Indicates that the flush completed successfully.
	 */
	static var FLUSHED : String;

	/**
	 * Indicates that the user is being prompted to increase disk space for the
	 * shared object before the flush can occur.
	 */
	static var PENDING : String;
}


#end
