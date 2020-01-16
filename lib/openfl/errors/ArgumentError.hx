package openfl.errors;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/errors/ArgumentError", "default")
#end
extern class ArgumentError extends Error
{
	public function new(message:String = "");
}
#else
typedef ArgumentError = flash.errors.ArgumentError;
#end
