package flash.net {
	
	
	/**
	 * @externs
	 * The SharedObjectFlushStatus class provides values for the code returned
	 * from a call to the `SharedObject.flush()` method.
	 */
	final public class SharedObjectFlushStatus {
		
		/**
		 * Indicates that the flush completed successfully.
		 */
		public static const FLUSHED:String = "flushed";
		
		/**
		 * Indicates that the user is being prompted to increase disk space for the
		 * shared object before the flush can occur.
		 */
		public static const PENDING:String = "pending";
		
	}
	
	
}