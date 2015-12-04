package openfl.net; #if (!display && !flash)


@:fakeEnum(String) enum SharedObjectFlushStatus {
	
	FLUSHED;
	PENDING;
	
}


#else


#if (flash && !display)


// TODO: Is this really right on Flash? It has a constructor?

@:native("flash.net.SharedObjectFlushStatus")
extern class SharedObjectFlushStatus {
	function new() : Void;
	static var FLUSHED : String;
	static var PENDING : String;
}


#else


/**
 * The SharedObjectFlushStatus class provides values for the code returned
 * from a call to the <code>SharedObject.flush()</code> method.
 */
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


#end
#end