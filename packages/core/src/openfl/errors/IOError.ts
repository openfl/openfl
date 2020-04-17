import Error from "../errors/Error";

/**
	The IOError exception is thrown when some type of input or output failure
	occurs. For example, an IOError exception is thrown if a read/write
	operation is attempted on a socket that has not connected or that has
	become disconnected.
**/
export default class IOError extends Error
{
	/**
		Creates a new IOError object.

		@param message A string associated with the error object.
	**/
	public constructor(message: string = "")
	{
		super(message);

		this.name = "IOError";
	}
}
