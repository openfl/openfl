package openfl.errors;

#if (display || !flash)
@:jsRequire("openfl/errors/ArgumentError", "default")
extern class ArgumentError extends Error
{
	public function new(message:String = "");
}
#else
typedef ArgumentError = flash.errors.ArgumentError;
#end
