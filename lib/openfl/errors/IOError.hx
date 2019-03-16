package openfl.errors;

#if (display || !flash)
@:jsRequire("openfl/errors/IOError", "default")
extern class IOError extends Error
{
	public function new(message:String = "");
}
#else
typedef IOError = flash.errors.IOError;
#end
