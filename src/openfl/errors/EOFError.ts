import IOError from "../errors/IOError";

/**
	An EOFError exception is thrown when you attempt to read past the end of
	the available data. For example, an EOFError is thrown when one of the read
	methods in the IDataInput interface is called and there is insufficient
	data to satisfy the read request.
**/
export default class EOFError extends IOError
{
	/**
		Creates a new EOFError object.

		@param message A string associated with the error object.
	**/
	public constructor(message: string = null, id: number = 0)
	{
		super("End of file was encountered");

		this.name = "EOFError";
		this.__errorID = 2030;
	}
}
