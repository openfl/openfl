package openfl.net;


/**
 * The SharedObjectFlushStatus class provides values for the code returned
 * from a call to the <code>SharedObject.flush()</code> method.
 */

#if flash
@:native("flash.net.SharedObjectFlushStatus")
#end


@:fakeEnum(String) enum SharedObjectFlushStatus {
	
	/**
	 * Indicates that the flush completed successfully.
	 */
	FLUSHED;
	
	/**
	 * Indicates that the user is being prompted to increase disk space for the
	 * shared object before the flush can occur.
	 */
	PENDING;
	
}