package openfl.errors;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/errors/RangeError", "default")
#end
extern class RangeError extends Error
{
	public function new(message:String = "");
}
#else
typedef RangeError = flash.errors.RangeError;
#end
