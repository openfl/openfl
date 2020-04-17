/**
	The SharedObjectFlushStatus class provides values for the code returned
	from a call to the `SharedObject.flush()` method.
**/
export enum SharedObjectFlushStatus
{
	/**
		Indicates that the flush completed successfully.
	**/
	FLUSHED = "flushed",

	/**
		Indicates that the user is being prompted to increase disk space for the
		shared object before the flush can occur.
	**/
	PENDING = "pending"
}

export default SharedObjectFlushStatus;
