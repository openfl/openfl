declare namespace openfl.net {
	
	export enum SharedObjectFlushStatus {
		
		/**
		 * Indicates that the flush completed successfully.
		 */
		FLUSHED = 0,
		
		/**
		 * Indicates that the user is being prompted to increase disk space for the
		 * shared object before the flush can occur.
		 */
		PENDING = 1
		
	}
	
}


export default openfl.net.SharedObjectFlushStatus;