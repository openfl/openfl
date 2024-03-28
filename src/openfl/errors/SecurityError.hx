package openfl.errors;

#if !flash
/**
	The SecurityError exception is thrown when some type of security violation
	takes place.

	Examples of security errors:

	- An unauthorized property access or method call is made across a security sandbox boundary.
	- An attempt was made to access a URL not permitted by the security sandbox.
	- A socket connection was attempted to an unauthorized port number, e.g. a port above 65535.
	- An attempt was made to access the user's camera or microphone, and the request to access the device was denied by the user.

**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class SecurityError extends Error
{
	public function new(message:String = "")
	{
		super(message, 0);

		name = "SecurityError";
	}
}
#else
typedef SecurityError = flash.errors.SecurityError;
#end
