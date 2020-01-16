package openfl.errors;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/errors/SecurityError", "default")
#end
extern class SecurityError extends Error
{
	public function new(message:String = "");
}
#else
typedef SecurityError = flash.errors.SecurityError;
#end
