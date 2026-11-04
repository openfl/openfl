package openfl.errors;

#if !flash
/**
	The IOError exception is thrown when some type of input or output failure
	occurs. For example, an IOError exception is thrown if a read/write
	operation is attempted on a socket that has not connected or that has
	become disconnected.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class IOError extends Error
{
	/**
		Creates a new IOError object.

		@param message A string associated with the error object.
		@param id      A reference number to associate with the specific error message.
	**/
	public function new(message:String = "", id:Int = 0)
	{
		super(message, id);

		name = "IOError";
	}
}
#else
typedef IOError = flash.errors.IOError;
#end
