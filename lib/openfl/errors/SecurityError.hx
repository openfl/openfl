package openfl.errors;

#if (display || !flash)
@:jsRequire("openfl/errors/SecurityError", "default")
extern class SecurityError extends Error
{
	public function new(message:String = "");
}
#else
typedef SecurityError = flash.errors.SecurityError;
#end
