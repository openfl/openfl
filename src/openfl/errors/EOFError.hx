package openfl.errors;

#if !flash
/**
	An EOFError exception is thrown when you attempt to read past the end of
	the available data. For example, an EOFError is thrown when one of the read
	methods in the IDataInput interface is called and there is insufficient
	data to satisfy the read request.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class EOFError extends IOError
{
	/**
		Creates a new EOFError object.

		@param message A string associated with the error object.
	**/
	public function new(message:String = null, id:Int = 0)
	{
		super("End of file was encountered");

		name = "EOFError";
		errorID = 2030;
	}
}
#else
typedef EOFError = flash.errors.EOFError;
#end
