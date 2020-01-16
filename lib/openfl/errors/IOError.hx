package openfl.errors;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/errors/IOError", "default")
#end
extern class IOError extends Error
{
	public function new(message:String = "");
}
#else
typedef IOError = flash.errors.IOError;
#end
