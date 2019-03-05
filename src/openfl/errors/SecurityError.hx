package openfl.errors;

#if !flash
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
