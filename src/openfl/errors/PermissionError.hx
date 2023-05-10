package openfl.errors;

/**
	Permission error is dispatched when the application tries to access a
	resource without requesting appropriate permissions.
**/
#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class PermissionError extends Error
{
	/**
		Creates a new instance of the PermissionError class.

		@param message The error description
		@param id The general error number
	**/
	public function new(message:String = "", id:Int = 0)
	{
		super(message, id);

		name = "PermissionError";
	}
}
#else
typedef PermissionError = flash.errors.PermissionError;
#end
